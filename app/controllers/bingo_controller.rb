class BingoController < ApplicationController
  def strip
    strip = Bingo::Strip.new(params[:game_id], params[:user_id])
    render json: strip
  end

  def pick
    game = Bingo::Game.new(params[:game_id])
    game.pick

    render json: game
  end
end
