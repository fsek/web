# encoding: UTF-8
require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Fsek
  class Application < Rails::Application
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :sv
    config.i18n.fallbacks = true

    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.autoload_paths += Dir["#{config.root}/app/mailers/concerns/**/"]
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{*/}')]

    config.time_zone = 'Stockholm'
    config.filter_parameters += [:password, :password_confirmation, :message]
    # Set taken from
    # https://github.com/rails/rails-html-sanitizer/blob/master/lib/rails/html/sanitizer.rb#L107
    WHITE_HTML_TAGS = Set.new(%w(strong em b i p code pre tt samp kbd var sub
                                 sup dfn cite big small address hr br div span
                                 h1 h2 h3 h4 h5 h6 ul ol li dl dt dd abbr
                                 acronym a img blockquote del ins table tr td th))
    config.action_view.sanitized_allowed_tags = WHITE_HTML_TAGS
    config.active_job.queue_adapter = :sidekiq

    config.action_cable.mount_path = '/cable'

    config.active_record.belongs_to_required_by_default = false
  end
end

Rack::Utils.multipart_part_limit = 512
