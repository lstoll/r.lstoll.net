from tornado import template, web, ioloop, iostream
import yaml
import os
import socket

content_len = 64 * 1024 #* 1024

stations = yaml.load(file('stations.yml', 'r'))

loader = template.Loader("views")
index_content = loader.load("index.html").generate(stations=stations)

class MainHandler(web.RequestHandler):
    def get(self):
        self.write(index_content)

class RadioHandler(web.RequestHandler):
    @web.asynchronous
    def get(self):
        self.auto_etag = False
        self.set_header('Content-Type', 'audio/x-aac') # audio/aacp?
        self.set_header('Accept-Ranges', 'bytes')
        station = stations[self.get_argument('station')]
        # See if we are the initial request, of a request for a specifc range.
        if self.request.headers.has_key('Range'):
            range_hdr = self.request.headers['Range']
            # Hacky, but we know our target browser..
            rng = range_hdr.split("=")[1].split("-")
            self.set_header('Content-Range', 'bytes ' + rng[0] + '-' + rng[1] + '/' + str(content_len))
            length = int(rng[1]) - int(rng[0]) + 1
            self.set_header('Content-Length', str(length))
            self.set_status(206)
            print "Got a range header, do the streaming stuff"
            # request for 2 bytes is the browser feeling up the server, making sure it works
            if length == 2:
                print "Dumping garbage for test request"
                # So give it what it wants
                self.write("xx")
                self.finish()
            else:
                print "For real request starting"
                # This is for real. Start streaming.
                print "Length: " + str(length)
                print "Range: "
                print rng
                s = socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0)
                self.stream = iostream.IOStream(s)
                self.stream.connect((station['host'], int(station['port'])), self.send_radio_request)
        # Initial Request - pretend we are long to start the multi part stuff
        else:
            self.set_header('Content-Length', content_len)
            self.write("paddingpaddingpaddingpadding")
            self.finish()

    def on_connection_close(self):
        print 'Connection closed'
        self.stream.close()
        #self.finish()

    def send_radio_request(self):
        self.stream.write("""GET / HTTP/1.0
Icy-MetaData:0

""")
        self.stream.read_until("""

""", self.on_icy_header)

    def on_icy_header(self, data):
        self.stream.read_bytes(65536, self.on_radio_chunk)

    def on_radio_chunk(self, data):
        print "Writing data..."
        self.write(data)
        self.flush()
        self.stream.read_bytes(65536, self.on_radio_chunk)


application = web.Application([
    (r"/", MainHandler),
    (r"/radio", RadioHandler),
    (r"/(.*)", web.StaticFileHandler, {"path": "public"}),
])

if __name__ == "__main__":
    application.listen(os.environ.get("PORT"))
    ioloop.IOLoop.instance().start()
