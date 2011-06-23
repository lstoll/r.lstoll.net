require 'rubygems'
require 'sinatra'

root_dir = File.expand_path(File.dirname(__FILE__) + "/..")
__FILE__ == $0 ? rack = false : rack = true

set :root, root_dir
set :views, File.join(root_dir, 'views')
set :app_file, File.join(root_dir, 'app', 'application.rb')
set :run, rack ? false : true
set :environment, ENV['RACK_ENV'] ? ENV["RACK_ENV"].to_sym : "development"

load File.join(root_dir, 'app', 'application.rb')
