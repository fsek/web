require 'rails_helper'
RSpec.describe Elections::NominationsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to :manage, Nomination

  before :each do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #new' do
    it 'valid election' do
      election = create(:election, :autumn)
      create(:position, :autumn)

      get :new
      assigns(:election_view).election.should eq(election)
      assigns(:election_view).nomination.should be_a_new(Nomination)
    end

    it 'valid election with position' do
      election = create(:election, :autumn)
      position = create(:position, :autumn)

      get :new, position: position.id

      response.should be_success
      assigns(:election_view).election.should eq(election)
      assigns(:election_view).nomination.should be_a_new(Nomination)
      assigns(:election_view).nomination.position.should eq(position)
    end

    it 'no valid election' do
      create(:position, :autumn)

      get :new
      response.should render_template('elections/no_election', layout: :application)
      response.status.should eq(404)
    end
  end

  describe 'POST #create' do
    it 'valid params' do
      create(:election, :autumn)
      position = create(:position, :autumn)
      attributes = { name: 'Hilbert Älg',
                     email: 'hilbert@fsektionen.se',
                     motivation: 'Underrum',
                     position_id: position.id }

      lambda do
        post :create, nomination: attributes
      end.should change(Nomination, :count).by(1)

      response.should redirect_to(new_nominations_path)
    end

    it 'invalid params' do
      create(:election, :autumn)
      create(:position, :autumn)
      attributes = { name: 'Hilbert Älg',
                     motivation: 'Underrum' }

      lambda do
        post :create, nomination: attributes
      end.should change(Nomination, :count).by(0)

      response.should render_template(:new)
      response.status.should eq(422)
    end
  end
end
