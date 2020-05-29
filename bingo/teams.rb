require "redis"

module Bingo
  class Teams
    class << self
      def get(game_id)
        blue = Bingo.redis.get("#{game_id}-blue-count").to_i || 1
        red = Bingo.redis.get("#{game_id}-red-count").to_i || 1
        if blue > red
          id = red + 1
          Bingo.redis.set("#{game_id}-red-count", id)
          return "red-#{id}"
        else
          id = blue + 1
          Bingo.redis.set("#{game_id}-blue-count", id)
          return "blue-#{id}"
        end
      end

      def nominate(game_id, exempt_player)
        blue_count = Bingo.redis.get("#{game_id}-blue-count").to_i || 0
        red_count = Bingo.redis.get("#{game_id}-red-count").to_i || 0

        blue_players = []
        blue_count.times do |b|
          blue_players << "blue_#{b}"
        end

        red_players = []
        red_count.times do |b|
          red_players << "red_#{b}"
        end

        red_players = red_players - [exempt_player]
        blue_players = blue_players - [exempt_player]


        red_players.shuffle!
        blue_players.shuffle!

        return {
          red: red_players,
          blue: blue_players
        }
      end
    end
  end
end
