require "bundler/capistrano"
require "capistrano-resque"
require "thinking_sphinx/capistrano"

set :application, "pi-base"
set :repository,  "git@github.com:jamesdabbs/pi-base.git"
set :scm,         :git
set :scm_verbose, true
set :deploy_via,  :remote_cache

server "192.81.219.239", :app, :web, :db, :resque_worker, :resque_scheduler, primary: true
set :workers, { "theorem" => 1, "trait" => 1 }

set :deploy_to, "/srv/web/brubeck"
set :user,      "brubeck"
set :use_sudo,  false

def link file
  path = "#{release_path}/config/#{file}"
  run "rm -f #{path} && ln -s /srv/web/brubeck/#{File.basename file} #{path}"
end

namespace :deploy do
  %w{ start stop restart }.each do |action|
    desc "#{action.capitalize} the Thin processes"
    task action do
      run "cd /srv/web/brubeck/current; bundle exec thin #{action} -C config/thin.yml"
    end
  end

  desc "copy credentials"
  task :copy_credentials do
    link "database.yml"
    link "initializers/secret_token.rb"
    link "initializers/email_settings.rb"
  end
end

after "deploy:update_code", "deploy:copy_credentials"
after "deploy:restart", "resque:restart"
after "deploy:restart", "deploy:cleanup"

require "new_relic/recipes"
after "deploy:update", "newrelic:notice_deployment"
