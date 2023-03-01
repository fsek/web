redis = { url: "redis://localhost:6379/#{ENV['SIDEKIQ_DB_NUMBER'] || 0}" }
schedule_file = "config/schedule.yml"

if Rails.env == "test"
  redis = { url: "redis://localhost:6379/0" }
end

Sidekiq.configure_server do |config|
  config.redis = redis

  if File.exist?(schedule_file) && Sidekiq.server?
    Sidekiq::Cron::Job.load_from_hash!(YAML.load_file(schedule_file))
  end
end

Sidekiq.configure_client do |config|
  config.redis = redis
end
