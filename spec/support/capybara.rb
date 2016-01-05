require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

Capybara.add_selector(:linkhref) do
  xpath { |href| ".//a[@href='#{href}']" }
end
