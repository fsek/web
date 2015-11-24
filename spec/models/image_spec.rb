require 'rails_helper'

RSpec.describe Image, type: :model do
  it 'has a valid factory' do
    build(:image).should be_valid
  end

  subject(:image) { build(:image) }
  let(:saved) { create(:image) }

  describe 'ActiveRecord associations' do
    it { should belong_to(:album) }
    it { should belong_to(:photographer) }
  end

  context 'callbacks' do
    describe 'public instance methods' do
      context 'responds to its methods' do
        it { saved.should respond_to(:original) }
        it { saved.should respond_to(:thumb) }
        it { saved.should respond_to(:view) }
        it { saved.should respond_to(:parent) }
      end
    end
  end
end
