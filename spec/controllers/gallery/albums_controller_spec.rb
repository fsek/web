require 'rails_helper'

RSpec.describe Gallery::AlbumsController, type: :controller do
  let(:user) { create(:user) }
  let(:album) { create(:album) }
  let(:not_member) { create(:user, member_at: nil) }
  let(:not_public) { create(:album, public: false) }

  describe 'GET #show member' do
    it 'assigns the requested album as @album' do
      allow(controller).to receive(:current_user) { user }
      get(:show, id: album.to_param)
      assigns(:album).should eq(album)
    end

  end
  describe 'GET #show non member' do
    before do
      allow(controller).to receive(:current_user) { user }
    end

    it 'assigns the requested album as @album' do
      get(:show, id: not_public.to_param)
      assigns(:album).should eq(not_public)
    end

    it 'assigns the requested album as @album' do
      get(:show, id: album.to_param)
      assigns(:album).should eq(album)
    end
  end
end
