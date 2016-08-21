require 'rails_helper'

RSpec.describe EventUsersController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to(:manage, [Event, EventUser])

  before(:each) do
       controller.stub(:current_user).and_return(user)
  end

  describe 'POST #create' do
    it 'works' do
      event = create(:event, :with_signup)

      attributes = { user_type: EventSignup::MEMBER }
      lambda do
        xhr(:post, :create, event_id: event.to_param, event_user: attributes)
      end.should change(EventUser, :count).by(1)

      EventUser.last.user.should eq(user)
    end

    it 'fails if signup has not yet opened' do
      event = create(:event)
      create(:event_signup, event: event, opens: Time.zone.now + 1.day,
                                          closes: Time.zone.now + 2.days)

      attributes = { user_type: EventSignup::MEMBER }
      lambda do
        xhr(:post, :create, event_id: event.to_param, event_user: attributes)
      end.should change(EventUser, :count).by(0)
    end

    it 'fails if signup has closed' do
      event = create(:event)
      create(:event_signup, event: event, opens: Time.zone.now - 2.days,
                                          closes: Time.zone.now - 1.day)

      attributes = { user_type: EventSignup::MEMBER }
      lambda do
        xhr(:post, :create, event_id: event.to_param, event_user: attributes)
      end.should change(EventUser, :count).by(0)
    end
  end

  describe 'DELETE #destroy' do
    it 'works' do
      event = create(:event, :with_signup)
      event_user = create(:event_user, event: event, user: user)

      lambda do
        xhr(:delete, :destroy, event_id: event.to_param, id: event_user.to_param)
      end.should change(EventUser, :count).by(-1)
    end

    it 'fails if signup is closed' do
      event = create(:event)
      signup = create(:event_signup, event: event)
      event_user = create(:event_user, event: event, user: user)
      signup.update(closes: Time.zone.now)

      lambda do
        xhr(:delete, :destroy, event_id: event.to_param, id: event_user.to_param)
      end.should change(EventUser, :count).by(0)
    end

    it 'does only allow owner to destroy' do
      event = create(:event, :with_signup)
      event_user = create(:event_user, event: event, user: create(:user))

      lambda do
        xhr(:delete, :destroy, event_id: event_user.event.to_param,
                              id: event_user.to_param)
      end.should raise_error(ActionController::RoutingError)
    end
  end
end
