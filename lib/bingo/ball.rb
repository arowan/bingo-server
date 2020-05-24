module Bingo
  class GameOver < StandardError; end
  class Ball
    def initialize
      @available_values = (1..90).to_a
      @taken_values = []
    end

    def pick
      if @available_values.empty?
        raise GameOver
      end
      @taken_values << @available_values.shuffle!.pop
      @taken_values.last
    end
  end
end
