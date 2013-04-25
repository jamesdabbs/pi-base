require "bundler/capistrano"

set :application, "brubeck"
set :repository,  "git@github.com:jamesdabbs/brubeck.git"
set :scm,         :git
set :scm_verbose, true
set :deploy_via,  :remote_cache

server "192.81.219.239", :app, :web, :db, primary: true

set :deploy_to, "/srv/web/brubeck"
set :user,      "brubeck"
set :use_sudo,  false

after "deploy:restart", "deploy:cleanup"

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
