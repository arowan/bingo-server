module Bingo
  class Player

    include ::Mongoid::Document

    field :game_id, type: Integer
    field :nickname, type: String
    field :team, type: String

    validates_presence_of :game_id
    validates_presence_of :nickname

    validates_uniqueness_of :nickname, scope: [:game_id]

    index({created_at: 1}, {expire_after_seconds: 1.day})

    embeds_one :strip

    before_create do |player|
      player.strip = Strip.new
      if player.game_id
        player.team = assign_team(player.game_id)
      end
    end

    def check
      game = Bingo::Game.find_by({game_id:  game_id})
      if !game.taken_values.empty?
        return { id: self.id.to_s, result: self.strip.check(game.taken_values).uniq! }
      end
      return false
    end

    def nominate
      players = self.class.where({game_id: game_id})
      players.reduce({}) do |grouped, player|
        if player != self
          team = grouped[player.team] || []
          grouped[player.team] = team.shuffle << player.nickname
        end
        grouped
      end
    end

    private

      def assign_team(game_id)
        last_player = self.class.where({game_id: game_id}).last
        last_player && last_player.team === 'blue' ? 'red' : 'blue'
      end

  end
end
