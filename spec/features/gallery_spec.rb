require 'rails_helper'
RSpec.feature 'Gallery' do
  include ControllerMacros

  context 'index page' do
    it 'visit index and album' do
      user = create(:user)
      album = create(:album_with_images)
      sign_in_as(user, gallery_path)

      page.status_code.should eq(200)

      within('.album-preview') do
        first(:linkhref, gallery_album_path(album)).click
      end

      page.status_code.should eq(200)
    end

    it 'visit old album' do
      user = create(:user)
      album = create(:album_with_images, start_date: Time.zone.local(1994, 3, 25))
      sign_in_as(user, gallery_path)

      page.status_code.should eq(200)

      within('.album-preview') do
        page.should have_no_selector(:linkhref, gallery_album_path(album))
      end

      first(:linkhref, gallery_path(year: album.start_date.year)).click
      page.status_code.should eq(200)

      within('.album-preview') do
        first(:linkhref, gallery_album_path(album)).click
      end

      page.status_code.should eq(200)
    end
  end

  context 'render album', js: true do
    it 'shows album' do
      user = create(:user)
      album = create(:album_with_images)
      sign_in_as(user, gallery_album_path(album))

      page.status_code.should eq(200)
    end
  end
end
