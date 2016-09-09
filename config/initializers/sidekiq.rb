redis = { url: "redis://localhost:6379/#{ENV['REDIS_DB_NUMBER'] || 0}" }
Sidekiq.configure_server do |config|
  config.redis = redis
end

Sidekiq.configure_client do |config|
  config.redis = redis
end
