require 'rails_helper'

RSpec.describe PositionUser.new, type: :model do
  let(:position_user) { build_stubbed(:position_user) }

  it { position_user.should be_valid }

  describe 'ActiveModel validations' do
    # Basic validations
    it { PositionUser.new.should validate_presence_of(:user) }
    it { PositionUser.new.should validate_presence_of(:position) }
    it 'validates uniqueness' do
      PositionUser.new.should validate_uniqueness_of(:user_id).scoped_to(:position_id).
        with_message(I18n.t('model.position_user.already_have_position'))
    end
  end

  describe 'ActiveRecord associations' do
    # Associations
    it { PositionUser.new.should belong_to(:position) }
    it { PositionUser.new.should belong_to(:user) }
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { position_user.should respond_to(:to_s) }
    end
  end
end
