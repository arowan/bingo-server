require "./bingo/ticket"

module Bingo
  class Strip
    include ::Mongoid::Document

    field :tickets, type: Array, default: -> { generate_tickets }
    embedded_in :player

    def generate_tickets
      available_values = build_available_values
      result = (1..6).reduce({ available_values: available_values, tickets: [] }) do |result, i|
        new_ticket = Ticket.generate(3, result[:available_values])
        result[:tickets] << new_ticket[:rows]
        result[:available_values] = new_ticket[:available_values]
        result
      end
      result[:tickets]
    end

    def check(used)
      tickets.map do |ticket|
        Ticket.check(ticket, used)
      end.compact
    end

    private

      def build_available_values
        ((ENV['MAX_NUMBER'] ? ENV['MAX_NUMBER'].to_i : 60) / 10).times.map do |i|
          i === 0 ? (1..9).to_a + Array.new(8) : (i * 10..i*10 +9).to_a + Array.new(8)
        end
      end
  end
end
