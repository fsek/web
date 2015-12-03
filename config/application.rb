# encoding: UTF-8
require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Fsek
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :sv
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.autoload_paths += Dir["#{config.root}/services/**/"]
    config.autoload_paths += Dir["#{config.root}/uploaders/**/"]
    config.autoload_paths += Dir["#{config.root}/validators/**/"]

    config.time_zone ='Stockholm'
    config.filter_parameters += [:password, :password_confirmation, :civic]
    config.active_record.raise_in_transactional_callbacks = true
  end
end
Rack::Utils.multipart_part_limit = 512
