require './jsonable'
require "redis"
require "json"

module Bingo
  def self.redis
    @redis ||= Redis.new
  end

  class GameOver < StandardError; end
  class Game < JSONable

    attr_reader :game_id, :available_values, :taken_values

    def initialize(game_id)
      @game_id = game_id
      saved = Bingo.redis.get(@game_id)
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

      Bingo.redis.set(@game_id, JSON.generate([@available_values, @taken_values]))

      @taken_values.last
    end
  end
end
