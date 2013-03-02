Brubeck::Application.routes.draw do
  devise_for :users

  resources :spaces, :properties, :traits, only: [:index, :show]

  get 'search', to: 'formulae#search'

  mount Precious::App, at: 'wiki'

  root to: 'application#root'
end
