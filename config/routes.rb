require 'sidekiq/web'
Rails.application.routes.draw do

  get '/help' => 'pages#help', as: 'help'

  root 'dashboard#index'

  get '/login' => 'sessions#new', as: 'login'
  post '/one_time_token' => 'sessions#one_time_token', as: 'one_time_token'
  post '/login' => 'sessions#create'

  get '/logout' => 'sessions#destroy', as: 'logout'

  resources :matches, only: [:index, :show]
  resources :questions, only: [:index, :show]

  resource :bet, only: [:show]
  get  '/bet/matches' => 'bets#matches', as: 'bet_matches'
  get  '/bet/questions' => 'bets#questions', as: 'bet_questions'

  get  '/bet/matches/:match_id' => 'match_bets#edit', as: 'match_bet'
  post '/bet/matches/:match_id' => 'match_bets#create'
  put  '/bet/matches/:match_id' => 'match_bets#update'

  get  '/bet/questions/:question_id' => 'question_bets#edit', as: 'question_bet'
  post '/bet/questions/:question_id' => 'question_bets#create'
  put  '/bet/questions/:question_id' => 'question_bets#update'

  # TODO limit access to admins, see https://github.com/mperham/sidekiq/wiki/Monitoring#security
  mount Sidekiq::Web => '/admin/sidekiq'

end
