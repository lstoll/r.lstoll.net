# Dreamhost Specific - wrap this somehow.
if ENV["RACK_ENV"] == 'production'
  ENV['RUBYLIB'] = "/home/lstoll/sw/lib/ruby/site_ruby/1.8"
  ENV['GEM_HOME'] = "/home/lstoll/sw/gems"
  ENV['GEM_PATH'] = "/home/lstoll/sw/gems:/usr/lib/ruby/gems/1.8"
end

root_dir = File.dirname(__FILE__)

require File.join(root_dir, 'app', 'runner.rb')
run Sinatra.application