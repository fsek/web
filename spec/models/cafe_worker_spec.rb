require 'rails_helper'

RSpec.describe CafeWorker, type: :model do
  it 'has a valid factory' do
    build_stubbed(:cafe_worker).should be_valid
  end

  describe 'ActiveModel validations' do
    # Basic validations
    it { CafeWorker.new.should validate_presence_of(:user_id) }
    it { CafeWorker.new.should validate_presence_of(:cafe_shift_id) }
  end

  describe 'ActiveRecord associations' do
    # Associations
    it { CafeWorker.new.should belong_to(:user) }
    it { CafeWorker.new.should belong_to(:cafe_shift) }
  end
end
