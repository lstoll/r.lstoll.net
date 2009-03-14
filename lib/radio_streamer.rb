## This class works as a rack body object, streaming back the audio 64 bytes at
## a time.

class RadioStreamer
  def initialize(station, length)
    @length = length
    @socket = TCPSocket.new(station['host'], station['port'])
    @socket.write("GET /" + station['file'] + " HTTP/1.0\r\nIcy-MetaData:0\r\n\r\n")
    # get us past the header crap
    buf = @socket.recv(9216)
  end

  def each
    chunks = @length/64
    remainder = @length % 64
    chunks_sent = 0
    while chunks_sent < chunks
      yield @socket.recv(64)
      chunks_sent += 1
    end
    # push the last bit
    yield @socket.recv(remainder) if remainder
    @socket.close
  end

  def to_result(cx, *args)
    self.each
  end
end