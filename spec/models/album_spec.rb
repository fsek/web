require 'rails_helper'

RSpec.describe Album, type: :model do
  subject { build_stubbed(:album) }
  it 'has a valid factory' do
    should be_valid
  end

  describe 'ActiveRecord associations' do
    it { should have_many(:images) }
  end
end
