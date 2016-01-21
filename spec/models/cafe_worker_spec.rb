require 'rails_helper'

RSpec.describe CafeWorker, type: :model do
  let(:worker) { build_stubbed(:cafe_worker) }

  it 'has a valid factory' do
    worker.should be_valid
  end

  describe 'ActiveModel validations' do
    # Basic validations
    it { worker.should validate_presence_of(:user_id) }
    it { worker.should validate_presence_of(:cafe_shift_id) }
  end

  describe 'ActiveRecord associations' do
    # Associations
    it { worker.should belong_to(:user) }
    it { worker.should belong_to(:cafe_shift) }
  end
end
