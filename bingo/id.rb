require "redis"
require "./bingo/game"
require "./bingo/teams"

module Bingo
  class Id
    def self.get(game_id, user_id)
      key = "#{game_id}-#{user_id}-id"
      saved = Bingo.redis.get(key)

      if saved
        return saved
      else
        begin
           id = Bingo::Teams.get(game_id)
          unless !!Bingo.redis.set(key, id, { ex: 86400, nx:true, xx:false })
            raise 'bad id'
          end
        rescue
          puts id
          retry
        end
        return id
      end
    end
  end
end
