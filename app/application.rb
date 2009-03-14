require 'rubygems'
require 'sinatra'
require 'json'

# require everything in lib
Dir.glob(File.join(File.dirname(__FILE__), 'lib/*.rb')).each {|f| require f }

# homepage
get '/' do
  erb :index
end

get '/radio' do
  station = Stations[params['station']]
end

# Configure Block.
configure do
  ROOT_DIR = File.expand_path(File.dirname(__FILE__) + "/..")
  Stations = YAML::load(File.open(File.join(ROOT_DIR, 'stations.yml')))
end
