module Bingo
  class GameOver < StandardError; end

  class Game
    include ::Mongoid::Document

    field :game_id, type: Integer, default: -> { rand(1000..99999) }
    field :available_values, type: Array, default: -> { (1..(ENV['MAX_NUMBER'] ? ENV['MAX_NUMBER'].to_i : 60) - 1).to_a  }
    field :taken_values, type: Array, default: -> { [] }
    field :scores, type: Hash, default: -> { { blue: 0, red: 0 } }

    validates :game_id, uniqueness: true

    index({created_at: 1}, {expire_after_seconds: 1.day})

    def pick!
      if available_values.empty?
        raise GameOver
      end

      taken_values << available_values.shuffle!.pop

      self.save
      taken_values.last
    end

    def point_for_team!(team)
      self.scores[team.to_sym] = self.scores[team.to_sym] + 1
      self.save
    end

    def challenges
      challenges = JSON.load(File.open(File.expand_path('../../challenges.json', __FILE__)))
      selection = challenges['selection'].reject!{|item| item['disabled'] }
      { challenges: selection.shuffle.first(3) }
    end

  end
end
