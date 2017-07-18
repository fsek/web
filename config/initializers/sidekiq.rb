redis = { url: "redis://localhost:6379/#{ENV['SIDEKIQ_DB_NUMBER'] || 0}" }

if Rails.env == "test"
  redis = { url: "redis://localhost:6379/0" }
end

Sidekiq.configure_server do |config|
  config.redis = redis
end

Sidekiq.configure_client do |config|
  config.redis = redis
end
