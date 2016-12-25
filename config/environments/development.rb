# encoding: UTF-8
Fsek::Application.configure do
  PUBLIC_URL = 'http://localhost:3000'.freeze
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify
  config.action_mailer.default_url_options = { host: PUBLIC_URL }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default charset: 'utf-8'

  config.action_mailer.smtp_settings = {
    address: '127.0.0.1',
    port: 1025,
    domain: PUBLIC_URL,
    authentication: 'plain',
    enable_starttls_auto: false
  }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
  config.serve_static_files = true
  config.assets.digest = false

  # Assets for mailers
  config.action_controller.asset_host = PUBLIC_URL
  config.action_mailer.asset_host = PUBLIC_URL

  config.action_view.raise_on_missing_translations = true

  # Don't log partials etc. in development.
  config.assets.quiet = true
  config.action_view.logger = nil

  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
    Bullet.add_footer = true
  end
end
