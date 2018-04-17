class MessageToken
  KEY_BASE = 'message_token_'.freeze

  def self.redis
    @redis ||= ::Redis.new(url: ActionCableConfig[:url])
  end

  def self.add(user_id)
    # Generate a random, unique token, save it to redis and returns it. The key will expire after 30 s.
    token = loop do
      new_token = SecureRandom.hex(37)
      break new_token if redis.setnx(KEY_BASE + new_token, user_id)
    end

    expires = 30.seconds.from_now.to_i
    redis.expireat(KEY_BASE + token, expires)

    data = { token: token, expires: expires }
  end

  # Finds the user_id for a token and removes the token
  def self.find(token)
    user_id = redis.get(KEY_BASE + token)
    redis.del(KEY_BASE + token)
    user_id
  end
end
