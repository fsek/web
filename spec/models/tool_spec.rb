require 'rails_helper'

RSpec.describe Tool, type: :model do
  describe :Validations do
    it 'check presence title' do
      tool = build(:tool)
      tool.should validate_presence_of(:title)
    end

    it 'check presence description' do
      tool = build(:tool)
      tool.should validate_presence_of(:description)
    end

    it 'check presence total' do
      tool = build(:tool)
      tool.should validate_presence_of(:total)
    end

    it 'check total greater than 0' do
      tool = build(:tool)
      tool.should validate_numericality_of(:total)
      tool.should_not allow_value(-1).for(:total)
      tool.should allow_value(1).for(:total)
    end
  end
end
