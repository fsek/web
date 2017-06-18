require 'rails_helper'
include MeetingHelper, TimeHelper

RSpec.describe MeetingsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to :manage, Meeting

  before(:each) do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    context 'html' do
      it 'sets proper variables' do
        meeting1 = create(:meeting, start_date: 1.hour.from_now, end_date: 3.hours.from_now)
        meeting2 = create(:meeting, start_date: 6.hours.from_now, end_date: 10.hours.from_now)

        get :index
        response.should have_http_status(200)
        assigns(:meetings).should eq([meeting1, meeting2])
      end
    end

    context 'json' do
      it 'sets proper variables' do
        meeting1 = create(:meeting, start_date: 1.hour.from_now, end_date: 3.hours.from_now)
        meeting2 = create(:meeting, start_date: 6.hours.from_now, end_date: 10.hours.from_now)
        create(:meeting, start_date: 13.hours.from_now, end_date: 15.hours.from_now)

        get :index, format: :json, params: { start: 1.hour.ago, end: 7.hours.from_now }
        response.body.should eq([meeting1, meeting2].to_json)
      end
    end
  end

  describe 'GET #show' do
    it 'assigns the requested rent as @meeting' do
      meeting = create(:meeting)

      get :show, params: { id: meeting.to_param }
      response.should have_http_status(200)
      assigns(:meeting).should eq(meeting)
    end
  end

  describe 'GET #new' do
    it :succeeds do
      get :new

      response.should have_http_status(200)
      assigns(:meeting).should be_a_new(Meeting)
    end
  end

  describe 'POST #create' do
    it 'valid parameters' do
      attributes = { start_date: 3.hours.from_now,
                     end_date: 7.hours.from_now,
                     title: 'Spider Meeting',
                     room: :sk }
      lambda do
        post :create, params: { meeting: attributes }
      end.should change(Meeting, :count).by(1)

      response.should redirect_to(edit_meeting_path(Meeting.last))
      assigns(:meeting).user.should eq(user)
      assigns(:meeting).title.should eq('Spider Meeting')
    end

    it 'invalid params' do
      attributes = { start_date: 3.hours.from_now,
                     end_date: 1.hours.from_now,
                     title: 'Spider Meeting',
                     room: :sk }
      lambda do
        post :create, params: { meeting: attributes }
      end.should change(Meeting, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'works with valid params' do
      meeting = create(:meeting, user: user, title: 'Wrong title')
      attributes = { title: 'Correct title' }
      patch :update, params: { id: meeting.to_param, meeting: attributes }

      meeting.reload
      meeting.title.should eq('Correct title')

      response.status.should eq(302)
      response.should redirect_to(edit_meeting_path(meeting))
      assigns(:meeting).should eq(meeting)
    end

    it 'fails with invalid params' do
      meeting = create(:meeting, user: user, title: 'Wrong title')
      attributes = { title: '' }
      patch :update, params: { id: meeting.to_param, meeting: attributes }

      meeting.reload
      meeting.title.should eq('Wrong title')

      response.status.should eq(422)
      response.should render_template(:edit)
      assigns(:meeting).should eq(meeting)
    end

    it 'fails with valid params if the status is confirmed' do
      meeting = create(:meeting, user: user, title: 'Wrong title',
                                 status: :confirmed, is_admin: true)
      attributes = { title: 'Correct title' }
      patch :update, params: { id: meeting.to_param, meeting: attributes }

      meeting.reload
      meeting.title.should eq('Wrong title')
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested meeting' do
      meeting = create(:meeting, user: user, room: :sk)

      lambda do
        delete :destroy, params: { id: meeting.to_param }
      end.should change(Meeting, :count).by(-1)

      response.should redirect_to(meetings_path(room: :sk))
    end
  end
end
