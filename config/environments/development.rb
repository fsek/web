# encoding: UTF-8
Fsek::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  config.secret_key_base = 'd328a97ab11dafe94db121b97c79a3713cde6357d46c229c02bb082b9c6530f6a6c9a39b841b65d34fca35266d4684b1e4b06a0fdc018a55062f515e3ba7e6d2'

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
  config.active_support.deprecation = :notify
  config.action_mailer.default_url_options = { host: 'dev.fsektionen.se' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default charset: 'utf-8'

  config.action_mailer.smtp_settings = {
    address: 'localhost',
    port: 1025
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
  PUBLIC_URL = 'dev.fsektionen.se'

  config.action_view.raise_on_missing_translations = true

  # Don't log partials etc. in development.
  config.quiet_assets = true
  config.action_view.logger = nil
end
