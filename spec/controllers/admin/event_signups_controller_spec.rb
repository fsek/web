require 'rails_helper'

RSpec.describe Admin::EventSignupsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to(:manage, [Event, EventSignup])

  describe 'GET #show' do
    it 'displays attending users and reserves correctly + sorts by group', pending: true do
      # Because of sort_by in EventUser.for_grid the records are not return
      # exactly according to the priority order in the views
      # The priority is used for all other concerns but it is overridden for the
      # order of all attending users
      # Until there is another way to force sorting by group without messing
      # with priority this is not accurate
      # dwessman, 2016-08-21
      event = create(:event)
      signup = create(:event_signup, event: event,
                                     custom: 37,
                                     novice: 20,
                                     mentor: 10,
                                     member: 5,
                                     slots: 7)

      group1 = create(:group) # will be first
      group2 = create(:group)
      group3 = create(:group)

      # Group 1
      first = new_event_user(event, EventSignup::CUSTOM, group1)
      second = new_event_user(event, EventSignup::NOVICE, group1)
      third = new_event_user(event, EventSignup::NOVICE, group1)
      fourth = new_event_user(event, EventSignup::MEMBER, group1)

      # Group 2
      eu1 = new_event_user(event, EventSignup::MEMBER, group2)
      eu4 = new_event_user(event, EventSignup::NOVICE, group2)
      eu7 = new_event_user(event, EventSignup::NOVICE, group2)

      # Group 3
      eu2 = new_event_user(event, EventSignup::MEMBER, group3)
      eu5 = new_event_user(event, EventSignup::CUSTOM, group3)
      eu8 = new_event_user(event, EventSignup::MEMBER, group3)

      # Expected results
      attend = [first, second, third, fourth, eu4, eu7, eu5]
      reserve = []

      get :show, params: { event_id: event.to_param, event_signup: signup }
      assigns(:event_signup).should eq(signup)
      assigns(:attending).should eq(attend)
      assigns(:reserves).should eq(reserve)
      response.status.should eq(200)
    end
  end

  describe 'GET #export as csv' do
    it 'exports properly' do
      event = create(:event, :with_signup)
      create(:event_user, event: event)
      create(:event_user, event: event)
      create(:event_user, event: event)

      get :export, format: :csv, params: { event_id: event }
      response.should have_http_status(200)
    end
  end

  private

  def new_event_user(event, type, group)
    create(:event_user, is_admin: true, event: event, user_type: type, group: group)
  end
end
