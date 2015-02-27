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
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Add /vendor/assets/fonts to autoload    
    config.assets.paths << "#{Rails}/vendor/assets/fonts"
    config.time_zone ='Stockholm'
    config.secret_token='53925521d781eeebea75a93a98a86e8aee9a3fac8b2be4c9ee4fed6f745899921e0b22502ee937fcfaa8cf4b471dd02ba8627ebb8b48f99c1975761c45ccd790'
    config.i18n.default_locale = :sv
    config.assets.precompile += ['application-print.css']
    config.filter_parameters += [:password,:password_confirmation,:civic]
  end
end
