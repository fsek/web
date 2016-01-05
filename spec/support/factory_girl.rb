require 'factory_girl'
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint FactoryGirl.factories
    ensure
      DatabaseCleaner.clean
    end
  end
end
