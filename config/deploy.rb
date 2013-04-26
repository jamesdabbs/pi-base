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

after "deploy:restart", "deploy:cleanup"
after "deploy:restart", "resque:restart"

namespace :deploy do
  %w{ start stop restart }.each do |action|
    desc "#{action.capitalize} the Thin processes"
    task action do
      run "cd /srv/web/brubeck/current; bundle exec thin #{action} -C config/thin.yml"
    end
  end
end

require "new_relic/recipes"
after "deploy:update", "newrelic:notice_deployment"
