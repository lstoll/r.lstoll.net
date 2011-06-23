root_dir = File.dirname(__FILE__)

require File.join(root_dir, 'app', 'runner.rb')
run Sinatra::Application
