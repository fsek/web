require 'rails_helper'

RSpec.describe Introduction, type: :model do
  it 'have valid factory' do
    build_stubbed(:introduction).should be_valid
  end
end
