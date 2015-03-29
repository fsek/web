RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do

    # Do not lint assignee, it is not ActiveRecord
    # /d.wessman
    factories_to_lint = FactoryGirl.factories.reject do |factory|
      factory.name =~ /assignee/
    end

    begin
      DatabaseCleaner.start
      FactoryGirl.lint factories_to_lint
    ensure
      DatabaseCleaner.clean
    end
  end
end
