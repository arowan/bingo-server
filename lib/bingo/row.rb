module Bingo
  class Row
    attr_reader :values

    def initialize
      @values = []
    end

    def pick(array)
      @values << array.shuffle!.pop
    end
  end
end
