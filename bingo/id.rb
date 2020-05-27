require "redis"

module Bingo
  class Id
    def self.get(game_id, user_id)
      key = "#{game_id}-#{user_id}"
      saved = Bingo.redis.get(key)

      if saved
        return saved.to_i
      else
        begin
           id = rand(1000...99999)
          unless !!Bingo.redis.set(key, id, { ex: 86400, nx:true, xx:false })
            raise 'bad id'
          end
        rescue
          retry
        end
        return id
      end
    end
  end
end
