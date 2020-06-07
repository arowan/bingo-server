require 'sinatra'
require "sinatra/reloader" if development?
require "sinatra/json"
require "sinatra/cors"

require 'mongoid'
Mongoid.load!(File.join(File.dirname(__FILE__), 'config', 'mongoid.yml'))

require './bingo/bingo'

set :allow_origin, "*"

before do
  content_type :json
end

post '/player' do
  begin
    body = JSON.parse(request.body.read)
    player = Bingo::Player.create({ game_id: body["game_id"], nickname: body["nickname"] })
    unless player.valid?
      status 400
    end
  rescue => error
    status 500
    json error.message
  end
  json player
end

get '/player/:id' do
  begin
    player = Bingo::Player.find(params[:id])
  rescue Mongoid::Errors::DocumentNotFound
    status 404
  end
  json player
end

get '/player/:id/check' do
  begin
    player = Bingo::Player.find(params[:id])
  rescue Mongoid::Errors::DocumentNotFound
    status 404
  end
  json player.check 
end

get '/player/:id/nominate' do
  begin
    player = Bingo::Player.find(params[:id])
    json player.nominate
  rescue Mongoid::Errors::DocumentNotFound
    status 404
  end
end

post '/game' do
  begin
    game = Bingo::Game.create
  rescue => error
    status 500
    json error.message
  end
  json game
end

put '/game/:id/pick' do
  begin
    game = Bingo::Game.find(params[:id])
  rescue Mongoid::Errors::DocumentNotFound
    status 404
  end

  begin
    game.pick!
  rescue ::Bingo::GameOver
  end

  json game
end
