Brubeck::Application.routes.draw do
  devise_for :users

  resources :spaces, :properties, :traits, only: [:index, :show]

  get 'search', to: 'formulae#search'

  authenticate :user do
    mount Precious::App, at: 'wiki'
  end

  root to: 'application#root'
end
