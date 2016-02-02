require 'rails_helper'

RSpec.describe Notice, type: :model do
  subject(:notice) { build(:notice) }
  describe :Validations do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:sort) }
  end
end
