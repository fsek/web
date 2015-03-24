RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    # Do not lint rent because it fails
    # See https://github.com/fsek/web/issues/72
    factories_to_lint = FactoryGirl.factories.reject do |factory|
      factory.name =~ /^rent/
    end
    begin
      DatabaseCleaner.start
      FactoryGirl.lint factories_to_lint
    ensure
      DatabaseCleaner.clean
    end
  end
end
