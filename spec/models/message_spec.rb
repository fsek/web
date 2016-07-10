require 'rails_helper'

RSpec.describe Message, type: :model do
  it { Message.new.should validate_presence_of(:content) }

  describe 'validations' do
    it 'is valid if user is in group' do
      user = create(:user)
      group = create(:group)
      m = Message.new(content: 'I got a text', user: user)
      m.should be_invalid
      m.errors[:groups].should include(I18n.t('model.message.need_groups'))

      m.groups << group
      m.should be_invalid
      m.errors[:groups].should include(I18n.t('model.message.not_part_of_selected_groups'))

      group.users << user
      m.should be_valid
      m.groups << create(:group)

      m.should be_invalid
      m.errors[:groups].should include(I18n.t('model.message.not_part_of_selected_groups'))
    end

    it 'is valid if admin' do
      user = create(:user)
      m = Message.new(content: 'with a text', user: user)
      m.groups << create(:group) << create(:group)
      m.should be_invalid
      m.errors[:groups].should include(I18n.t('model.message.not_part_of_selected_groups'))

      m.is_admin = true
      m.should be_valid
    end
  end

  describe 'with_group' do
    it 'is true if any group overlap' do
      sender = create(:user)
      group = create(:group)
      message = Message.new(content: 'A text', user: sender)
      message.groups << group << create(:group)
      message.is_admin = true

      message.save!
      user = create(:user)
      user.groups << create(:group)

      message.with_group(user).should be_falsey
      user.groups << group

      message.with_group(user).should be_truthy
    end
  end
end
