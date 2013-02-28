require 'gollum/frontend/app'

Brubeck::Application.routes.draw do
  devise_for :users

  # mount Precious::App => "/"

  root to: 'application#root'
end
