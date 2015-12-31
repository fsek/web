require 'rails_helper'

FactoryGirl.factories.map(&:name).each do |factory_name|
  RSpec.describe %(#{factory_name} factory) do
    # Test each factory
    it 'is valid' do
      factory = FactoryGirl.build(factory_name)
      if factory.respond_to?(:valid?)
        factory.should be_valid, lambda { factory.errors.full_messages.join("\n") }
      end
    end
  end
end
