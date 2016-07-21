require 'rails_helper'

RSpec.describe Tool, type: :model do
  describe :Validations do
    it 'check presence title' do
      tool = build(:tool)
      tool.should validate_presence_of(:title)
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


    it 'check total not under rented tools' do
      tool = create(:tool, total: 1)
      create(:tool_renting, tool: tool)
      tool.total = 0
      tool.valid?.should eq(false)
      tool.errors[:total].should include(I18n.t('model.tool.not_allowed_change_total'))
    end
  end

  describe 'method free' do
    it 'check renting' do
      tool = create(:tool)
      (1..tool.total).each do |i|
        create(:tool_renting, tool: tool)
        tool.free.should eq(tool.total - i)
      end
    end
  end
end
