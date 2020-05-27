require 'sinatra'
require "sinatra/reloader" if development?
require "sinatra/json"
require "sinatra/cors"

require './bingo/strip'
require './bingo/game'
require './bingo/id'

set :allow_origin, "*"

before do
  content_type :json
end

get '/strip/:game_id' do
  id = Bingo::Id.get(params[:game_id], params[:user_id])
  strip = Bingo::Strip.new(id)
  json strip
end

get '/pick/:game_id' do
  game = Bingo::Game.new(params[:game_id])
  game.pick

  json game
end

post '/check/:game_id' do
  id = params[:ticket_id]
  game = Bingo::Game.new(params[:game_id])
  result = game.check(id)

  result = {
    result: result,
    nominated_players: Bingo::Teams.nominate(params[:game_id], params[:ticket_id])
  }

  json result
end
