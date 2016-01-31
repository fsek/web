# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
# Do preferebly add it to 'spec/support/*'
require 'shoulda/matchers'
require 'rspec/example_steps'
require 'devise'

ActiveRecord::Migration.maintain_test_schema!

# Loads page_objects which are used in feature test
Dir[Rails.root.join('spec/page_objects/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.include FactoryGirl::Syntax::Methods

  # Allow for I18n in tests
  config.include AbstractController::Translation

  # Allow for route-helpers in tests
  config.include Rails.application.routes.url_helpers

  config.include Devise::TestHelpers, type: :controller
  config.extend ControllerMacros

  # Clear uploaded files
  config.after(:each) do
    if Rails.env.test? || Rails.env.cucumber?
      FileUtils.rm_rf(Dir["#{Rails.root}/spec/support/uploads"])
    end
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
