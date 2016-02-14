require 'rails_helper'

RSpec.describe Contact, type: :model do
  subject(:contact) { build(:contact) }

  describe :Validations do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:text) }
    it { should validate_uniqueness_of(:email) }
  end

  describe :associations do
    it { should belong_to(:post) }
  end
end
