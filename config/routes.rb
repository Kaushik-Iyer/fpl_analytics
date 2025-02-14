require 'sidekiq/web'
require 'sidekiq/cron/web'
Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "home#index"
  resources :players, only: [:index]
  get 'teams/standings', to: 'teams#standings'
  get 'players/top_performers', to: 'players#top_performers'
  get 'fixtures/upcoming', to: 'fixtures#upcoming'
  get 'players/search', to: 'players#search'
  get 'players/performance', to: 'players#performance'
  get 'players/in_form_players', to: 'players#in_form_players'
  get 'players/in_form_filter', to: 'players#in_form_filter'
  get 'managers/show', to: 'managers#show'
  post 'chat/respond', to: 'chat#respond'
  get 'players/unavailable', to: 'players#unavailable'
  get 'players/most_transferred', to: 'players#most_transferred'
  get '/metrics', to: 'metrics#show'

  # Mount the Sidekiq web UI at /sidekiq
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == 'admin' && password == 'password'
  end
  mount Sidekiq::Web, at: '/sidekiq'
end
