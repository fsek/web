require 'rails_helper'

RSpec.describe Admin::AlbumsController, type: :controller do
  let(:user) { create(:admin) }

  allow_user_to(:manage, [Album, Image])

  describe 'GET #show' do
    it 'assigns the requested album as @album' do
      album = create(:album)

      get :show, params: { id: album.to_param }
      assigns(:album).should eq(album)
    end
  end

  describe 'GET #new' do
    it 'assigns a new album as @album' do
      get(:new)
      assigns(:album).should be_a_new(Album)
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
    it 'works with valid parameters' do
      attributes = { title_sv: 'Välkomstgasque',
                     description_sv: 'Detta är en välkomstgasque!',
                     location: 'Kårhuset: Gasquesalen',
                     start_date: 2.days.ago,
                     end_date: 2.days.ago + 5.hours }

      lambda do
        post :create, params: { album: attributes }
      end.should change(Album, :count).by(1)

      response.should redirect_to(admin_album_path(Album.last))
    end

    it 'does not work with invalid parameters' do
      attributes = { title_sv: 'Välkomstgasque',
                     end_date: 2.days.ago + 5.hours }

      lambda do
        post :create, params: { album: attributes }
      end.should change(Album, :count).by(0)

      response.should render_template(:new)
      response.should have_http_status(422)
    end
  end

  describe 'PATCH #update' do
    it 'valid parameters' do
      album = create(:album, title: 'Välkomstgasque')

      img = 'app/assets/images/hilbert.jpg'
      album_params = { title_sv: 'Nollegasque',
                       photographer_user: user.id,
                       photographer_name: user.firstname,
                       image_upload: [Rack::Test::UploadedFile.new(File.open(img))] }

      patch :update, params: { id: album.to_param, album: album_params }

      album.reload
      album.title.should eq('Nollegasque')
      response.should redirect_to(admin_album_path(album))
      album.images.count.should eq(1)
      album.images.last.photographer.should eq(user)
      album.images.last.photographer_name.should eq(user.firstname)
    end

    it 'invalid parameters' do
      album = create(:album, title: 'Välkomstgasque')
      patch :update, params: { id: album.to_param, album: { title_sv: nil } }

      album.reload
      album.title.should eq('Välkomstgasque')
      response.should render_template(:show)
      response.should have_http_status(422)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys record' do
      album = create(:album)

      lambda do
        delete :destroy, params: { id: album.to_param }
      end.should change(Album, :count).by(-1)

      response.should redirect_to(admin_albums_path)
    end
  end

  describe 'DELETE #destroy_images' do
    it 'destroys all images' do
      album = create(:album_with_images, image_count: 3)
      album.images.size.should eq(3)

      lambda do
        delete :destroy_images, params: { id: album.to_param }
      end.should change(Image, :count).by(-3)
      album.reload
      album.images.should be_empty
    end
  end
end
