require 'rails_helper'

RSpec.describe Message, type: :model do
  it { Message.new.should validate_presence_of(:content) }

  describe 'validations' do
    it 'is valid if user is in group' do
      intro = create(:introduction)
      user = create(:user)
      group = create(:group, introduction: intro)
      m = Message.new(content: 'I got a text', user: user, introduction: intro)
      m.should be_invalid
      m.errors[:groups].should include(I18n.t('model.message.need_groups'))

      m.groups << group
      m.should be_invalid
      m.errors[:groups].should include(I18n.t('model.message.not_part_of_selected_groups'))

      create(:group_user, group: group, user: user)
      user.reload

      m.should be_valid
      m.groups << create(:group, introduction: intro)

      m.should be_invalid
      m.errors[:groups].should include(I18n.t('model.message.not_part_of_selected_groups'))
    end

    it 'is valid if admin' do
      intro = create(:introduction)
      user = create(:user)
      m = Message.new(content: 'with a text', user: user, introduction: intro)
      m.groups << create(:group, introduction: intro) << create(:group, introduction: intro)
      m.should be_invalid
      m.errors[:groups].should include(I18n.t('model.message.not_part_of_selected_groups'))

      m.by_admin = true
      m.should be_valid
    end
  end

  describe 'with_group' do
    it 'is true if any group overlap' do
      intro = create(:introduction)
      sender = create(:user)
      group = create(:group, introduction: intro)
      message = Message.new(content: 'A text', user: sender, introduction: intro)
      message.groups << group << create(:group, introduction: intro)
      message.by_admin = true

      message.save!
      user = create(:user)
      user.groups << create(:group, introduction: intro)

      message.with_group(user).should be_falsey
      user.groups << group

      message.with_group(user).should be_truthy
    end
  end
end
