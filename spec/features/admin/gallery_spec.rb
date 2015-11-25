require 'rails_helper'
feature 'Gallery' do
  let(:user) { create(:admin) }
  let(:album_w_img) { create(:album_with_images) }
  let(:album) { create(:album) }
  let(:new_album) { build(:album) }
  let(:login) { LoginPage.new }

  background do
    album.reload
    login.visit_page.login(user, '12345678')
  end

  it 'visit index and update album' do
    page.visit admin_gallery_albums_path

    page.status_code.should eq(200)
    first(:linkhref, admin_gallery_album_path(album)).click

    fill_in('album_title', with: 'Ny titel')
    find('#submit-album').click

    page.status_code.should eq(200)
    album.reload
    album.title.should eq('Ny titel')
  end

  it 'visit index and update album' do
    page.visit admin_gallery_albums_path

    page.status_code.should eq(200)
    first(:linkhref, new_admin_gallery_album_path).click

    fill_in('album_title', with: new_album.title)
    fill_in('album_description', with: new_album.description)
    fill_in('album_start_date', with: new_album.start_date)
    find('#submit-album').click

    page.should have_css('div.alert.alert-info')
    find('div.alert.alert-info').text.should \
      include(I18n.t(:success_create))
  end
end
