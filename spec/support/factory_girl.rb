#encoding: UTF-8
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  factories_to_lint = FactoryGirl.factories.reject do |factory|
    factory.name =~ /rent|assignee/
  end

  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint factories_to_lint
    ensure
      DatabaseCleaner.clean
    end
  end
end
