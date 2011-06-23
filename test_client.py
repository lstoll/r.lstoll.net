import sys

from tornado.ioloop import IOLoop
from tornado.iostream import IOStream
import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0)
s.connect(("shoutmedia.abc.net.au", 10326))
stream = IOStream(s)

def on_body(data):
    sys.stdout.write(data)
    stream.read_bytes(4096, on_body)
    #stream.close()
    #IOLoop.instance().stop()

stream.write("""GET / HTTP/1.0

""")
stream.read_bytes(4096, on_body)
#stream.read_until("""
#
#""", on_headers)
IOLoop.instance().start()
