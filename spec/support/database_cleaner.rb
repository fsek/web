require 'database_cleaner'

RSpec.configure do |config|
  # Cleans out database before each test suite is run
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  # Use transactions for normal tests
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
