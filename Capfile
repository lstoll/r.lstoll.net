load 'deploy' if respond_to?(:namespace) # cap2 differentiator
 
default_run_options[:pty] = true

set :user, 'lstoll'
set :domain, 'r.lstoll.net'
set :application, 'r.lstoll.net'
set :repository,  "ssh://hg@bitbucket.org/lstoll/rlstollnet/"
set :deploy_to, "~/#{application}" 
set :scm, 'mercurial'
set :scm_verbose, true
set :use_sudo, false
set :group, "deploy"
set :ssh_options, { :forward_agent => true } # this is so we don't need a appdeploy key
 
server domain, :app, :web
 
namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt" 
  end
end
