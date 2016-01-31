RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :should
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = [:expect, :should]
    mocks.verify_partial_doubles = true
  end

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  # Need to be disabled to allow :should syntax
  # config.disable_monkey_patching!

  config.order = :random

  Kernel.srand config.seed

  # Nice for checking, not working on Circle CI
  # config.profile_examples = 10
end
