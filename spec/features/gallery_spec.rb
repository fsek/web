require 'rails_helper'
RSpec.feature 'Gallery', js: true do
  let(:user) { create(:user) }
  let(:album) { create(:album_with_images) }
  let(:old_album) do
    create(:album_with_images, start_date: Time.zone.local(1994, 3, 25))
  end
  let(:login) { LoginPage.new }

  background do
    album.reload
    old_album.reload
    login.visit_page.login(user, '12345678')
  end

  it 'visit index and album' do
    page.visit gallery_path

    page.status_code.should eq(200)
    first(:linkhref, gallery_album_path(album)).click

    page.visit gallery_album_path(album, image: album.images.last.id)
    page.status_code.should eq(200)
  end

  it 'visit old album' do
    page.visit gallery_path
    page.status_code.should eq(200)

    page.should have_no_selector(:linkhref, gallery_album_path(old_album))

    first(:linkhref, gallery_path(year: old_album.start_date.year)).click
    page.status_code.should eq(200)

    first(:linkhref, gallery_album_path(old_album)).click
    page.status_code.should eq(200)
  end
end
