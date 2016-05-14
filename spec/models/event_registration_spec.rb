require 'rails_helper'

RSpec.describe EventRegistration, type: :model do
  describe 'Associations' do
    it { EventRegistration.new.should belong_to(:user) }
    it { EventRegistration.new.should belong_to(:event) }
  end

  describe 'validations' do
    it { EventRegistration.new.should validate_presence_of(:user_id) }
    it { EventRegistration.new.should validate_presence_of(:event_id) }
    it 'validate uniqueness scoped to user_id' do
      EventRegistration.new.should validate_uniqueness_of(:event_id).scoped_to(:user_id)
    end
  end
end
