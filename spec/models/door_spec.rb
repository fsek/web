require 'rails_helper'

RSpec.describe Door, type: :model do
  it 'has a valid factory' do
    build_stubbed(:door).should be_valid
  end
end
