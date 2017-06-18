require 'rails_helper'

RSpec.describe Gallery::AlbumsController, type: :controller do
  let(:user) { create(:user) }
  allow_user_to(:show, Album)

  describe 'GET #show member' do
    it 'assigns the requested album as @album' do
      album = create(:album)
      get :show, params: { id: album.to_param }

      response.should have_http_status(200)
      assigns(:album).should eq(album)
      response.should have_http_status(200)
    end

    it 'assigns start based on given index' do
      album = create(:album)
      get :show, params: { id: album.to_param, start: '37' }

      response.should have_http_status(200)
      assigns(:start).should eq(37)
    end
  end
end
