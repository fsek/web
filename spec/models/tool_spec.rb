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

    it 'check rent with no free' do
      tool = create(:tool, total: 1)
      rent_valid = create(:tool_renting, renter: 'Adrian', tool_id: tool.id)

      rent = build(:tool_renting, tool_id: tool.id)
      rent.valid?.should eq(false)
      rent.errors[:returned].should include('no more tools to rent')

      # Check update rent with no frees
      rent_valid.renter = 'Roth'
      rent_valid.valid?.should eq(true)
    end

    it 'check total not under rented tools' do
      tool = create(:tool, total: 1)
      create(:tool_renting, tool: tool)
      tool.total = 0
      tool.valid?.should eq(false)
      tool.errors[:total].should include('not allowed to change total below rented tools')
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
