Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "home#index"

  get 'teams/standings', to: 'teams#standings'
  get 'players/top_performers', to: 'players#top_performers'
  get 'fixtures/upcoming', to: 'fixtures#upcoming'
  get 'players/search', to: 'players#search'
  get 'players/performance', to: 'players#performance'
  get 'players/in_form_players', to: 'players#in_form_players'
  get 'players/in_form_filter', to: 'players#in_form_filter'
end
