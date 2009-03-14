require 'rubygems'
require 'sinatra'
require 'json'
require 'socket'

# require everything in lib
Dir.glob(File.join(File.dirname(__FILE__), '../lib/*.rb')).each {|f| load f }

# homepage
get '/' do
  erb :index
end

get '/radio' do
  station = Stations[params['station']]
  if env['HTTP_RANGE']
    range_string = env['HTTP_RANGE'].split('=')[1]
    range = range_string.split('-').collect{|s| s.to_i}
    length = range[1] - range[0] + 1
    
    headers({'Content-type' => 'audio/mpeg', 'Accept-Ranges' => 'bytes',
        'Content-Length' => length.to_s, # about 1 hr at 128k
        'Content-Range' => 'bytes ' + range[0].to_s + '-' + range[1].to_s + '/76800000'});

    throw :halt, [206, RadioStreamer.new(station, length)]
  else
    # we have no range, initial request to check file size, set the content type and range.
    headers({'Content-type' => 'audio/mpeg', 'Accept-Ranges' => 'bytes',
        'Content-Length' => '76800000'}); # about 1hr20 at 128k
    'padding'
  end
end

# Configure Block.
configure do
  ROOT_DIR = File.expand_path(File.dirname(__FILE__) + "/..")
  Stations = YAML::load(File.open(File.join(ROOT_DIR, 'stations.yml')))
end
