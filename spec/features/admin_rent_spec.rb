require 'rails_helper'
feature 'admin tries to login' do
  let(:user) { create(:admin) }
  let(:rent) { build(:rent) }
  scenario 'they get alert with text "Loggade in"' do
    visit '/logga_in'
    fill_in 'user_username', with: user.username
    fill_in 'user_password', with: '12345678'
    click_button 'Logga in'
    page.should have_css('div.alert.alert-info') # Verify we get an alert
    find('div.alert.alert-info').text.should include('Loggade in.') # Verify that the alert states we are signed in
    # TODO Include warden to stub login
    #login_as(user, scope: :user)

    # Test notice
    visit admin_rents_path
    find('h2#notice-headline').text.should include('Notiser')
    find(:linkhref, new_notice_path).click
    fill_in 'notice_title', with: notice.title
    fill_in 'notice_description', with: notice.description
    find(:css, "#notice_public").set(notice.public)
    fill_in 'notice[d_publish]', with: notice.d_publish
    fill_in 'notice[d_remove]', with: notice.d_remove
    fill_in 'notice_sort', with: notice.sort
    find('#submit-notice').click

    page.should have_css('div.alert.alert-info')
    find('div.alert.alert-info').text.should include(%(#{I18n.t(:notice)} #{I18n.t(:success_create)}))
  end
end
