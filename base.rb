require 'sinatra'
require "sinatra/reloader" if development?
require "sinatra/json"
require "sinatra/cors"

require 'mongoid'
Mongoid.load!(File.join(File.dirname(__FILE__), 'config', 'mongoid.yml'))

require './bingo/bingo'

set :allow_origin, "*"
set :allow_methods, "GET,HEAD,POST,PUT"

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
  rescue => error
    status 500
    json error.message
  end
  json player
end

get '/player/:id/check' do
  begin
    player = Bingo::Player.find(params[:id])
  rescue Mongoid::Errors::DocumentNotFound
    status 404
  rescue => error
    status 500
    json error.message
  end
  json player.check
end

get '/player/:id/nominate' do
  begin
    player = Bingo::Player.find(params[:id])
    json player.nominate
  rescue Mongoid::Errors::DocumentNotFound
    status 404
  rescue => error
    status 500
    json error.message
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

get '/game/:game_id' do
  begin
    game = Bingo::Game.find_by({game_id: params[:game_id]})
  rescue Mongoid::Errors::DocumentNotFound
    status 404
  rescue => error
    status 500
    json error.message
  end

  json game
end

put '/game/:game_id/pick' do
  begin
    game = Bingo::Game.find_by({game_id: params[:game_id]})
  rescue Mongoid::Errors::DocumentNotFound
    status 404
  rescue => error
    status 500
    json error.message
  end

  begin
    game.pick!
  rescue ::Bingo::GameOver
  rescue => error
    status 500
    json error.message
  end

  json game
end

put '/game/:game_id/point/:team' do
  begin
    game = Bingo::Game.find_by({game_id: params[:game_id]})
    game.point_for_team!(params[:team])
  rescue Mongoid::Errors::DocumentNotFound
    status 404
  rescue => error
    status 500
    json error.message
  end

  json game
end

get '/game/:game_id/challenges' do
  begin
    game = Bingo::Game.find_by({game_id: params[:game_id]})
  rescue Mongoid::Errors::DocumentNotFound
    status 404
  rescue => error
    status 500
    json error.message
  end

  json  game.challenges
end

get '/game/:game_id/players' do
  begin
    game = Bingo::Game.find_by({game_id: params[:game_id]})
  rescue Mongoid::Errors::DocumentNotFound
    status 404
  rescue => error
    status 500
    json error.message
  end

  json game.players
end
