module Bingo
  class Player

    include ::Mongoid::Document

    field :game_id, type: Integer
    field :nickname, type: String
    field :team, type: String

    index({created_at: 1}, {expire_after_seconds: 1.day})

    embeds_one :strip

    before_create do |player|
      player.strip = Strip.new
      if player.game_id
        player.team = assign_team(player.game_id)
      end
    end

    private

      def assign_team(game_id)
        last_player = self.class.where({game_id: game_id}).last
        last_player && last_player.team === 'blue' ? 'red' : 'blue'
      end

  end
end
