require "./jsonable"
require "redis"
require "json"
require "./bingo/ticket"

module Bingo
  class Strip < JSONable
    attr_reader :tickets, :id

    def initialize(id)
      @id = id
      saved = Bingo.redis.get(id)

      if saved
        @tickets = JSON.parse(saved).map do |t|
          Ticket.new(t['rows'], t['available_values'])
        end
      else
        @tickets = build_strip
        Bingo.redis.set(id, @tickets.to_json, {ex: 86400})
      end
    end

    def build_strip
      available_values = build_available_values
      result = (1..6).reduce({ available_values: available_values, tickets: [] }) do |result, i|
        new_ticket = Ticket.new([], result[:available_values])
        new_ticket.generate
        result[:tickets] << new_ticket
        result[:available_values] = new_ticket.available_values
        result
      end
      result[:tickets]
    end

    def check(used)
      @tickets.map{|t| t.check(used) }.compact
    end


    private
      def build_available_values
        ((ENV['MAX_NUMBER'].to_i || 60) / 10).times.map do |i|
          i === 0 ? (1..9).to_a + Array.new(8) : (i * 10..i*10 +9).to_a + Array.new(8)
        end
      end
  end
end
