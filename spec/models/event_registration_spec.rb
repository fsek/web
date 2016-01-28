require 'rails_helper'

RSpec.describe EventRegistration, type: :model do
  let(:user) { create(:user) }
  let(:event) { create(:event) }
  let(:reg) { create(:event_registration, event: event, user: user) }

  describe 'Associations' do
    it { reg.should belong_to(:user) }
    it { reg.should belong_to(:event) }
  end

  describe 'validations' do
    it { reg.should validate_presence_of(:user_id) }
    it { reg.should validate_presence_of(:event_id) }
    it 'validate uniqueness scoped to user_id' do
      # More explicitly written because of issue
      # https://github.com/thoughtbot/shoulda-matchers/issues/880
      reg
      reg.should validate_uniqueness_of(:event_id).scoped_to(:user_id)
    end
  end
end
