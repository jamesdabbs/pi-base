require "bundler/capistrano"
require "capistrano-resque"

set :application, "brubeck"
set :repository,  "git@github.com:jamesdabbs/brubeck.git"
set :scm,         :git
set :scm_verbose, true
set :deploy_via,  :remote_cache

server "192.81.219.239", :app, :web, :db, :resque_worker, :resque_scheduler, primary: true
set :workers, { "theorem" => 1, "trait" => 1 }

set :deploy_to, "/srv/web/brubeck"
set :user,      "brubeck"
set :use_sudo,  false


namespace :deploy do
  %w{ start stop restart }.each do |action|
    desc "#{action.capitalize} the Thin processes"
    task action do
      run "cd /srv/web/brubeck/current; bundle exec thin #{action} -C config/thin.yml"
    end
  end

  desc "copy db config file"
  task :copy_db_config do
    run "rm #{release_path}/config/database.yml && ln -s /srv/web/brubeck/database.yml #{release_path}/config/database.yml"
  end
end

after "deploy:update_code", "deploy:copy_db_config"
after "deploy:restart", "resque:restart"
after "deploy:restart", "deploy:cleanup"

require "new_relic/recipes"
after "deploy:update", "newrelic:notice_deployment"
