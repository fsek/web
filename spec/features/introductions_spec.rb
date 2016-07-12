require 'rails_helper'

RSpec.feature 'visit introductions' do
  let(:user) { create(:user) }
  before(:each) do
    sign_in_as(user)
  end

  it 'visits current introduction' do
    create(:introduction, title: 'En Ridderlig Nollning', current: true)

    page.visit(introductions_path)
    page.should have_http_status(200)
    find('.headline > h1').text.should include('En Ridderlig Nollning')
  end

  it 'visit introductions, render archive' do
    create(:introduction, title: 'En Ridderlig Nollning', current: false)

    page.visit(introductions_path)
    page.should have_http_status(404)
    find('.headline > h1').text.should include(I18n.t('introductions.archive.title'))
  end
end
