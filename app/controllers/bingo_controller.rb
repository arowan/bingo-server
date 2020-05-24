class BingoController < ApplicationController
  def strip
    strip = Bingo::Strip.new
    render json: strip
  end
end
