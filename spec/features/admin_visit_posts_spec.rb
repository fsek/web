require 'rails_helper'
feature 'admin logged in' do
  let(:user) { create(:admin) }
  let(:council) { create(:council) }
  let(:post) { create(:post, council: council, elected_by: 'Terminsmötet') }

  scenario 'they try to visit posts for council' do
    visit new_user_session_path
    fill_in 'user_username', with: user.username
    fill_in 'user_password', with: '12345678'
    click_button 'Logga in'
    page.should have_css('div.alert.alert-info')
    find('div.alert.alert-info').text.should include(I18n.t('devise.sessions.signed_in'))

    visit edit_council_path(council)
    find('label.reg-header').text.should include('Redigera utskott')

    visit council_posts_path(council)
    page.status_code.should == 200
  end
end
