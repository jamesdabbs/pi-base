require 'resque/server'

Brubeck::Application.routes.draw do
  devise_for :users

  resources :spaces, :properties, :traits, :theorems, only: [:index, :show]

  get 'search', to: 'formulae#search'

  authenticate :user, lambda { |u| u.admin? } do
    mount Resque::Server.new, at: '/resque', as: 'resque'
  end

  root to: 'application#root'
end
