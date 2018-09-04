require 'rails_helper'

RSpec.describe(NotificationsController, type: :controller) do
  let(:user) { create(:user) }
  allow_user_to([:visit, :index, :look_all], Notification)

  before(:each) do
    allow(Rpush::Gcm::App).to receive(:find_by!) { Rpush::Gcm::App.new }
    allow(Rpush::Gcm::Notification).to receive(:create!) { Rpush::Gcm::Notification.new }
  end

  describe 'PATCH #visit' do
    it 'marks notification as visited' do
      notification = create(:notification, :create, user: user, seen: false, visited: false)
      set_current_user(user)

      patch :visit, params: { id: notification.to_param }
      response.should have_http_status(200)

      notification.reload
      notification.visited?.should be_truthy
    end
  end

  describe 'GET #index' do
    it 'renders users notifications' do
      set_current_user(user)
      first = create(:notification, :create, user: user)
      second = create(:notification, :create, user: user)
      # Another users notification
      third = create(:notification, :create)

      get(:index)
      response.should have_http_status(200)
      assigns(:notifications).should include(first)
      assigns(:notifications).should include(second)
      assigns(:notifications).should_not include(third)
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
    end
  end
end
