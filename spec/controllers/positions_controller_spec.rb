require 'rails_helper'

RSpec.describe PositionsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to(:manage, Position)
  allow_user_to(:manage, Council)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #show' do
    it 'sets election and position' do
      election = create(:election, :autumn)
      position = create(:position, :autumn)

      get(:show, id: position.to_param)
      response.should have_http_status(200)
      assigns(:election).should eq(election)
      assigns(:position).should eq(position)
    end

    it 'returns 404 if no election' do
      Election.stub(:current) { nil }
      position = create(:position)

      get(:show, id: position.to_param)
      response.should have_http_status(404)
      response.should render_template('elections/no_election')
    end
  end

  describe 'GET #modal' do
    it 'renders modal' do
      create(:election, :autumn)
      position = create(:position, :autumn)

      xhr(:get, :modal, id: position.to_param)
      response.should have_http_status(200)
    end

    it 'renders error page' do
      position = create(:position, :autumn)

      xhr(:get, :modal, id: position.to_param)
      response.should have_http_status(404)
    end
  end
end
