module ActionCableConfig
  # Read a value from cable.yml
  def self.[](key)
    unless @config
      template = ERB.new(File.read(Rails.root + 'config/cable.yml'))
      @config = YAML.load(template.result(binding))[Rails.env].symbolize_keys
    end

    @config[key]
  end
end

# Clear ConnectedLists from redis when the server starts
if defined?(Rails::Server) && !Rails.env.test?
  redis = Redis.new(url: ActionCableConfig[:url])

  begin
    keys = redis.scan_each(match: "connected_to_group_*").to_a
    redis.del(keys) unless keys.blank?
    Rails.logger.info('[ConnectedList]: Successfully cleared list of connected users.')
  rescue
    Rails.logger.error('[ConnectedList]: Failed to clear ConnectedList from redis. Have you started redis?')
    Rails.logger.warn('[ConnectedList]: The list of users connected with action cable has not been reset.')
  end
end
