require 'rails_helper'

RSpec.describe Album, type: :model do
  it 'has a valid factory' do
    build(:album).should be_valid
  end
  subject(:album) { build(:album) }
  let(:saved) { create(:album) }

  describe 'ActiveRecord associations' do
    it { should have_many(:images) }
  end
end
