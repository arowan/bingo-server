require 'sinatra'
require "sinatra/reloader" if development?
require "sinatra/json"
require './bingo/strip'
require './bingo/game'

before do
  content_type :json
end

get '/strip/:game_id' do
  strip = Bingo::Strip.new(params[:game_id], params[:user_id])
  json strip
end

get '/pick/:game_id' do
  game = Bingo::Game.new(params[:game_id])
  game.pick

  json game
end