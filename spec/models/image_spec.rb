require 'rails_helper'

RSpec.describe Image, type: :model do
  it 'has a valid factory' do
    build(:image).should be_valid
  end

  describe 'ActiveRecord associations' do
    it { Image.new.should belong_to(:album) }
    it { Image.new.should belong_to(:photographer) }
  end

  context 'callbacks' do
    describe 'public instance methods' do
      context 'responds to its methods' do
        it { Image.new.should respond_to(:original) }
        it { Image.new.should respond_to(:thumb) }
        it { Image.new.should respond_to(:view) }
        it { Image.new.should respond_to(:parent) }
      end
    end
  end
end
