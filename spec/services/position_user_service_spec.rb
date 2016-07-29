require 'rails_helper'

RSpec.describe PositionUserService do
  describe :valid do
    it :create do
      position_user = build(:position_user)
      PositionUserService.create(position_user).should be_truthy
    end
  end

  describe :invalid do
    it :create do
      position_user = build(:position_user)
      position_user.position.stub(:limited?).and_return(true)
      PositionUserService.create(position_user).should be_falsey
    end
  end
end
