# require "./jsonable"
# require "./bingo/row"

module Bingo
#   class Ticket < JSONable
#     attr_accessor :rows, :available_values
#
#     def initialize(rows = [], available_values = [])
#       @rows = rows.map{ |r|  Row.new(r['values']) }
#       @available_values = available_values
#     end
#
#     def generate
#       @rows, @available_values = build_rows(3, available_values)
#     end
#
#
#

#   end

  class Ticket
    class << self
      def generate(amount_of_rows, available_values)
        (1..amount_of_rows).reduce({ rows: [], available_values: available_values }) do |result, row|
          new_row = []
          result[:available_values].each do |available_array|
            new_row << available_array.shuffle!.pop
          end
          result[:rows] << new_row
          result
        end
      end

      def check(rows, used)
        result = rows.reduce(0) do |sum, row|
          (rows.compact - used).empty? ? sum + 1 : sum
        end
        result > 0 ? result : nil
      end
    end
  end
end
