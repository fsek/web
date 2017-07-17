class ConnectedList
  KEY_BASE = 'connected_to_group_'.freeze

  def self.redis
    @redis ||= ::Redis.new(url: ActionCableConfig[:url])
  end

  def self.add(user_id, group_id)
    # Add the user to the end of the list. The user will be added n times if n connections are opened
    redis.rpush(KEY_BASE + group_id.to_s, user_id)
  end

  def self.remove(user_id, group_id)
    # Remove the first occurrence of the user from the list
    redis.lrem(KEY_BASE + group_id.to_s, 1, user_id)
  end

  def self.connected(group_id)
    # Get all the users from the list (-1 is the end of the list), then select unique in ruby
    redis.lrange(KEY_BASE + group_id.to_s, 0, -1).map(&:to_i).uniq
  end

  def self.clear_all(group_id)
    redis.del(KEY_BASE + group_id.to_s)
  end
end
