require "redis"
require "json"

module Bingo
  class GameOver < StandardError; end
  class Game

    attr_reader :game_id, :available_values, :taken_values

    def initialize(game_id)
      @game_id = game_id
      _redis = Redis.new
      saved = _redis.get(@game_id)
      if saved
        @available_values, @taken_values = JSON.parse(saved)
      else
        @available_values = (1..90).to_a
        @taken_values = []
      end
    end

    def pick
      if @available_values.empty?
        raise GameOver
      end

      @taken_values << @available_values.shuffle!.pop

      _redis = Redis.new
      _redis.set(@game_id, [@available_values, @taken_values].to_json)

      @taken_values.last
    end
  end
end
