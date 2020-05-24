require './jsonable'
require "redis"
require "json"
require './bingo/ticket'

module Bingo
  class Strip < JSONable

    attr_reader :tickets

    def initialize(game_id, user_id)
      key = "#{game_id}-#{user_id}"
      saved = Bingo.redis.get(key)

      if saved
        @tickets = JSON.parse(saved)
      else
        @tickets = build_strip
        Bingo.redis.set(key, @tickets.to_json)
      end
    end

    def build_strip
      available_values = build_available_values
      result = (0..6).reduce({ available_values: available_values, tickets: [] }) do |result, i|
        new_ticket = Ticket.new(result[:available_values])
        result[:tickets] << new_ticket
        result[:available_values] = new_ticket.available_values
        result
      end
      result[:tickets]
    end

    private

      def build_available_values
        [
          (1..9).to_a + Array.new(9),
          (10..19).to_a + Array.new(9),
          (20..29).to_a + Array.new(9),
          (30..39).to_a + Array.new(9),
          (40..49).to_a + Array.new(9),
          (50..59).to_a + Array.new(9),
          (60..69).to_a + Array.new(9),
          (70..79).to_a + Array.new(9),
          (80..89).to_a + Array.new(9),
        ]
      end

  end
end
