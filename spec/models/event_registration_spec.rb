require 'rails_helper'

RSpec.describe EventRegistration, type: :model do
  let(:user) { create(:user) }
  let(:event) { create(:event) }
  let(:reg) { create(:event_registration, event: event, user: user) }

  describe 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:event_id) }
    it { should validate_uniqueness_of(:event_id).scoped_to(:user_id) }
  end

  describe 'Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:event) }
  end
end

