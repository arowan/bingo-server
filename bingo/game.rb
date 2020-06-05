module Bingo
  class GameOver < StandardError; end

  class Game
    include ::Mongoid::Document

    field :game_id, type: Integer, default: -> { rand(1000..99999) }
    field :available_values, type: Array, default: -> { (1..(ENV['MAX_NUMBER'] ? ENV['MAX_NUMBER'].to_i : 60)).to_a  }
    field :taken_values, type: Array, default: -> { [] }

    validates :game_id, uniqueness: true

    index({created_at: 1}, {expire_after_seconds: 1.day})

    # def check(id)
    #   strip = Bingo::Strip.new(id)
    #   if !@taken_values.empty?
    #     strip.check(@taken_values).uniq
    #   else
    #     false
    #   end
    # end
    
    def pick
      if available_values.empty?
        raise GameOver
      end

      taken_values << available_values.shuffle!.pop

      self.save
      taken_values.last
    end
  end
end
