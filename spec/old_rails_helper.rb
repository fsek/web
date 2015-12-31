ENV['RAILS_ENV'] ||= 'test'

require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

# This line imports all files in support
# All configuration and import of a certain dependency should be done
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Add additional requires below this line. Rails is not loaded until this point!
# Do preferebly add it to 'spec/support/*'
require 'shoulda/matchers'
require 'rspec/example_steps'
require 'devise'
# Ta bort - klurigt med test av filuppladdning
# include ActionDispatch::TestProcess

# Checks for pending migrations before tests are run.
ActiveRecord::Migration.maintain_test_schema!

# Loads page_objects which are used in feature test
Dir[Rails.root.join('spec/page_objects/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  # Allow for I18n in tests
  config.include AbstractController::Translation

  # Allow for route-helpers in tests
  config.include Rails.application.routes.url_helpers

  config.include Devise::TestHelpers, type: :controller
end
