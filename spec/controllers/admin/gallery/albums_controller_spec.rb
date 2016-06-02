require 'rails_helper'

RSpec.describe Admin::Gallery::AlbumsController, type: :controller do
  let(:user) { create(:admin) }

  allow_user_to(:manage, :all)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #show' do
    it 'assigns the requested album as @album' do
      album = create(:album)

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
      create(:album, title: 'Second', start_date: 5.days.ago)
      create(:album, title: 'First', start_date: 4.days.ago)
      create(:album, title: 'Third', start_date: 6.days.ago)

      get(:index)
      assigns(:albums).map(&:title).should eq(['First', 'Second', 'Third'])
    end
  end

  describe 'POST #create' do
    it 'posts new album' do
      attributes = { title_sv: 'Välkomstgasque',
                     description_sv: 'Detta är en välkomstgasque!',
                     location: 'Kårhuset: Gasquesalen',
                     start_date: 2.days.ago,
                     end_date: 2.days.ago + 5.hours }

      lambda do
        post :create, album: attributes
      end.should change(Album, :count).by(1)

      response.should redirect_to(admin_gallery_album_path(Album.last))
    end
  end

  describe 'PATCH #update' do
    it 'update album' do
      album = create(:album, title: 'Välkomstgasque')
      patch(:update, id: album.to_param, \
                     album: { title_sv: 'Nollegasque',
                              image_upload: [Rack::Test::UploadedFile.new(File.open('app/assets/images/hilbert.jpg'))],
                              photographer_user: user.id, photographer_name: user.firstname })

      album.reload
      album.title.should eq('Nollegasque')
      response.should redirect_to(admin_gallery_album_path(album))
      album.images.count.should eq(1)
      album.images.last.photographer.should eq(user)
      album.images.last.photographer_name.should eq(user.firstname)
    end
  end
end
