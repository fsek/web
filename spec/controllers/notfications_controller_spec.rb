require 'rails_helper'

RSpec.describe(NotificationsController,
               type: :controller) do
  let(:user) { create(:user) }
  allow_user_to([:look, :index, :look_all], Notification)

  describe 'POST #look' do
    it 'marks notification as seen' do
      notification = create(:notification, :create, user: user, seen: false)
      set_current_user(user)

      post :look, xhr: true, params: { id: notification.to_param }
      response.should have_http_status(200)

      notification.reload
      notification.seen?.should be_truthy
    end
  end

  describe 'GET #index' do
    it 'renders users notifications' do
      set_current_user(user)
      first = create(:notification, :create, user: user)
      second = create(:notification, :create, user: user)
      # Another users notification
      create(:notification, :create)

      get(:index)
      response.should have_http_status(200)
      assigns(:notifications).should eq([first, second])
    end
  end

  describe 'GET #look_all' do
    it 'sets all notifications as seen' do
      set_current_user(user)
      create(:notification, :create, user: user, seen: false)
      create(:notification, :create, user: user, seen: false)
      create(:notification, :create, user: user, seen: false)
      create(:notification, :create, user: user, seen: true)
      user.update(notifications_count: user.notifications.not_seen.count)

      lambda do
        get(:look_all)
      end.should change(user, :notifications_count).by(-3)
      user.notifications.not_seen.count.should eq(0)

      response.should redirect_to(own_user_notifications_path)
    end
  end
end
