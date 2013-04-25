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

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

require "new_relic/recipes"
after "deploy:update", "newrelic:notice_deployment"
