from tornado import template, web, ioloop
import yaml
import os

stations = yaml.load(file('stations.yml', 'r'))

loader = template.Loader("views")
index_content = loader.load("index.html").generate(stations=stations)

class MainHandler(web.RequestHandler):
    def get(self):
        self.write(index_content)

application = web.Application([
    (r"/", MainHandler),
    (r"/(.*)", web.StaticFileHandler, {"path": "public"}),
])

if __name__ == "__main__":
    application.listen(os.environ.get("PORT"))
    ioloop.IOLoop.instance().start()
