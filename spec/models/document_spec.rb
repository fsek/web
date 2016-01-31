require 'rails_helper'

RSpec.describe Document, type: :model do
  describe 'valid factory' do
    it 'has valid factory' do
      build(:document).should be_valid
    end
  end

  describe 'associations' do
    it 'belongs_to user' do
      Document.new.should belong_to(:user)
    end
  end
end
