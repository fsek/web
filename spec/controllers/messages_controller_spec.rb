require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to(:manage, [Group, Message])

  describe 'GET #index' do
    it 'render and sort by latest first' do
      user = create(:user)
      group = create(:group)
      GroupUser.create!(group: group, user: user)
      Message.create!(content: 'Last', user: user, groups: [group], created_at: 5.minutes.ago,
                      introduction: group.introduction)
      Message.create!(content: 'Second', user: user, groups: [group], created_at: 2.minutes.ago,
                      introduction: group.introduction)
      Message.create!(content: 'First', user: user, groups: [group], created_at: 1.minute.ago,
                      introduction: group.introduction)

      get(:index, group_id: group.to_param)
      response.should have_http_status(200)
      assigns(:messages).map(&:content).should eq(['First', 'Second', 'Last'])
    end
  end

  describe 'GET #new' do
    it 'sets new message' do
      group = create(:group)
      get(:new, group_id: group.to_param)

      response.should have_http_status(200)
      assigns(:message).should be_a_new(Message)
    end
  end

  describe 'POST #create' do
    it 'valid parameters' do
      set_current_user(user)
      group = create(:group)
      group.users << user
      attributes = { content: 'Most amazing thing just happened!' }
      lambda do
        post(:create, group_id: group.to_param, message: attributes)
      end.should change(Message, :count).by(1)

      response.should redirect_to(group_path(group))
      Message.last.user.should eq(user)
    end

    it 'invalid parameters' do
      set_current_user(user)
      group = create(:group)
      group.users << user
      attributes = { content: nil }
      lambda do
        post(:create, group_id: group.to_param, message: attributes)
      end.should change(Message, :count).by(0)

      response.should have_http_status(422)
      response.should render_template(:new)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroy message' do
      user = create(:user)
      group = create(:group)
      GroupUser.create!(group: group, user: user)
      set_current_user(user)
      m = Message.create!(content: 'I got a text',
                          user: user,
                          groups: [group],
                          introduction: group.introduction)
      request.env['HTTP_REFERER'] = group_path(group)
      lambda do
        delete(:destroy, group_id: group.to_param, id: m.to_param)
      end.should change(Message, :count).by(-1)

      response.should redirect_to(group_path(group))
    end
  end
end
