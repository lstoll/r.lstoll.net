require 'rubygems'
require 'sinatra'

root_dir = File.expand_path(File.dirname(__FILE__) + "/..")
__FILE__ == $0 ? rack = false : rack = true

Sinatra::Application.default_options.merge!(
    :views    => File.join(root_dir, 'views'),
    :app_file => File.join(root_dir, 'app', 'application.rb'),
    :run => rack ? false : true,
    :env => ENV['RACK_ENV'] ? ENV["RACK_ENV"].to_sym : "development"
)
require File.join(root_dir, 'app', 'application.rb')
