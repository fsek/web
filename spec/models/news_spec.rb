require 'rails_helper'

RSpec.describe News, type: :model do
  it 'has valid factory' do
    build_stubbed(:news).should be_valid
  end
end
