require 'rails_helper'

RSpec.describe Gallery::AlbumsController, type: :controller do
  let(:user) { create(:user) }
  let(:album) { create(:album_with_images) }
  let(:not_member) { create(:user, member_at: nil) }

  describe 'GET #show member' do
    it 'assigns the requested album as @album' do
      allow(controller).to receive(:current_user) { user }
      get(:show, id: album.to_param)
      assigns(:album).should eq(album)
      assigns(:album).images.should eq (Image.where(album: album).order(filename: :asc))
    end
  end
end
