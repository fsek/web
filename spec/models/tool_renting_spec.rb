require 'rails_helper'

RSpec.describe ToolRenting, type: :model do
  describe :Validations do
    it 'check presence user_id' do
      ToolRenting.new.should validate_presence_of(:user_id)
    end

    it 'check presence tool' do
      ToolRenting.new.should validate_presence_of(:tool)
    end

    it 'check presence return_date' do
      ToolRenting.new.should validate_presence_of(:return_date)
    end

    context 'free tools' do
      it 'valid with free tool' do
        tool = create(:tool, total: 1)
        rent = create(:tool_renting, user_id: 1, tool_id: tool.id)

        rent.user_id = 2
        rent.valid?.should eq(true)
      end

      it 'invalid without free tool' do
        tool = create(:tool, total: 1)
        create(:tool_renting, user_id: 1, tool_id: tool.id)

        tool.reload
        tool.free.should eq(0)

        rent = build(:tool_renting, tool_id: tool.id)
        rent.valid?.should eq(false)
        rent.errors[:returned].should include(I18n.t('model.tool_renting.no_more_tools'))
      end
    end
  end
end
