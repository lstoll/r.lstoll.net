require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'

# require everything in lib
Dir.glob(File.join(File.dirname(__FILE__), 'lib/*.rb')).each {|f| require f }

# homepage
get '/' do
  erb :index
end

# Configure Block.
configure do
#  config_file = File.expand_path("~/.services.lstoll.net/config.yaml")
#  if FileTest.exists?(config_file)
#    Config = YAML::load(File.open(config_file))
#  else
#    message = "Config file does not exist at #{config_file}, exiting"
#    Utils.send_email('lstoll@lstoll.net', "Lincoln Stoll", 'lstoll@me.com', "Lincoln Stoll", "services startup error", message)
#    puts message
#    exit
#  end
end
