require 'rails_helper'

RSpec.describe ExLink, type: :model do
  it 'has a valid factory' do
    build(:ex_link).should be_valid
  end

  subject { build(:ex_link) }
  let(:ex_link) { create(:ex_link) }

  describe 'ActiveModel validations' do
    it { should validate_presence_of(:label) }
    it { should validate_uniqueness_of(:label) }
    it { should validate_presence_of(:url) }
    it { should validate_uniqueness_of(:url) }
  end

  describe 'ActiveRecord associations' do
    it { should have_many(:ex_link_tags) }
    it { should have_many(:tags) }
  end

  context 'callbacks' do
    describe 'public instance methods' do
      context 'responds to its methods' do
        it { ex_link.should respond_to(:tags) }
      end
    end
  end
end
