require 'rails_helper'

RSpec.describe Admin::EventSignupsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to(:manage, [Event, EventSignup])

  describe 'GET #show' do
    it 'displays attending users and reserves correctly + sorts by group' do
      event = create(:event)
      signup = create(:event_signup, event: event, custom: 37, novice: 20,
                                     mentor: 10, member: 5, slots: 7)

      group1 = create(:group)
      group2 = create(:group)
      group3 = create(:group)

      eu0 = create(:event_user, is_admin: true, event: event, user_type: EventSignup::MEMBER,
                                                              group: group1)
      eu1 = create(:event_user, is_admin: true, event: event, user_type: EventSignup::MEMBER,
                                                              group: group2)
      eu2 = create(:event_user, is_admin: true, event: event, user_type: EventSignup::MEMBER,
                                                              group: group3)
      eu3 = create(:event_user, is_admin: true, event: event, user_type: EventSignup::NOVICE,
                                                              group: group1)
      eu4 = create(:event_user, is_admin: true, event: event, user_type: EventSignup::NOVICE,
                                                              group: group2)
      eu5 = create(:event_user, is_admin: true, event: event, user_type: EventSignup::CUSTOM,
                                                              group: group3)
      eu6 = create(:event_user, is_admin: true, event: event, user_type: EventSignup::MENTOR,
                                                              group: group1)
      eu7 = create(:event_user, is_admin: true, event: event, user_type: EventSignup::NOVICE,
                                                              group: group2)
      eu8 = create(:event_user, is_admin: true, event: event, user_type: EventSignup::MEMBER,
                                                              group: group3)
      eu9 = create(:event_user, is_admin: true, event: event, user_type: EventSignup::CUSTOM,
                                                              group: group1)

      # Expected results
      attend = [eu9, eu3, eu6, eu0, eu4, eu7, eu5]
      reserve = [eu1, eu2, eu8]

      get(:show, event_id: event.to_param, event_signup: signup)
      assigns(:event_signup).should eq(signup)
      assigns(:attending).should eq(attend)
      assigns(:reserves).should eq(reserve)
      response.status.should eq(200)
    end
  end
end
