require 'rails_helper'

RSpec.describe Admin::Gallery::AlbumsController, type: :controller do
  let(:user) { create(:admin) }
  let(:album) { create(:album) }
  let(:new_album) { build(:album) }

  # Should be Album, Image and :gallery
  # Cannot get it to work /dwessman
  allow_user_to(:manage, :all)

  before(:each) do
    album.reload
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #show' do
    it 'assigns the requested album as @album' do
      get(:show, id: album.to_param)
      assigns(:album).should eq(album)
    end
  end

  describe 'GET #new' do
    it 'assigns a new album as @album' do
      get(:new)
      assigns(:album).new_record?.should be_truthy
      assigns(:album).instance_of?(Album).should be_truthy
    end
  end

  describe 'GET #index' do
    it 'assigns albums sorted as @albums' do
      get(:index)
      assigns(:albums).should match_array(Album.all.order(start_date: :desc))
    end
  end

  describe 'POST #create' do
    it 'posts new album' do
      lambda do
        post :create, album: attributes_for(:album)
      end.should change(Album, :count).by(1)

      response.should redirect_to(admin_gallery_album_path(Album.last))
    end
  end

  describe 'PATCH #update' do
    it 'update album' do
      patch(:update, id: album.to_param, \
            album: { title: 'Hej',
                     image_upload: [Rack::Test::UploadedFile.new(File.open('app/assets/images/hilbert.jpg'))],
                     photographer_user: user.id, photographer_name: user.firstname })
      album.reload
      album.title.should eq('Hej')
      response.should redirect_to(admin_gallery_album_path(album))
      album.images.count.should eq(1)
      album.images.last.photographer.should eq(user)
      album.images.last.photographer_name.should eq(user.firstname)
    end
  end
end
