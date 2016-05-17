require 'rails_helper'

RSpec.describe ToolRenting, type: :model do
  describe :Validations do
    it 'check presence renter' do
      ToolRenting.new.should validate_presence_of(:renter)
    end

    it 'check presence tool' do
      ToolRenting.new.should validate_presence_of(:tool)
    end

    it 'check presence return_date' do
      ToolRenting.new.should validate_presence_of(:return_date)
    end
  end
end
