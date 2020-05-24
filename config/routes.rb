Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/strip/:game_id', to: 'bingo#strip'
  get '/pick/:game_id', to: 'bingo#pick'
end
