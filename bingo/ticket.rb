require './jsonable'
require './bingo/row'

module Bingo
  class Ticket < JSONable

    attr_reader :rows, :available_values

    def initialize(available_values)
      @rows, @available_values = build_rows(3, available_values)
    end

    def build_rows(amount_of_rows, available_values)
      result = (1..amount_of_rows).reduce({ rows: [], available_values: available_values }) do |result, row|
        new_row = Row.new
        result[:available_values].each do |available_array|
          new_row.pick(available_array)
        end
        result[:rows] << new_row
        result
      end
      result.values
    end

  end
end
