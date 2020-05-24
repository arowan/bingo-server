require './jsonable'
module Bingo
  class Row < JSONable
    attr_reader :values

    def initialize
      @values = []
    end

    def pick(array)
      @values << array.shuffle!.pop
    end
  end
end
