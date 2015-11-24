require 'rails_helper'

RSpec.describe GalleryController, type: :controller do
  let(:user) { create(:user) }
  let(:album) { create(:album) }
  let(:old_album) { create(:album, start_date: Time.zone.parse('1986-03-25T12:00:00')) }

  before(:each) do
    allow(controller).to receive(:current_user) { user }
    album.reload
    old_album.reload
  end

  allow_user_to :manage, :gallery
  allow_user_to :manage, Album

  describe 'GET #index' do
    it 'assigns albums for current year as @albums' do
      get(:index)
      assigns(:albums).should match_array(Album.gallery(Time.zone.now))
    end

    it 'assigns albums for assigned year as @albums' do
      old_album.reload
      get(:index, year: old_album.start_date.year)
      assigns(:albums).should include(old_album)
    end
  end
end
