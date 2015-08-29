require 'rails_helper'
feature 'admin create notice' do
  let(:user) { create(:admin) }
  let(:notice) { build(:notice) }
  let(:login) { LoginPage.new }

  Steps 'Create menu' do
    And 'I sign in' do
      login.visit_page.login(user, '12345678')
    end

    And 'visit menu index' do
      visit notices_path
      find('h2#notice-headline').text.should include('Notiser')
      find(:linkhref, new_notice_path).click
    end

    And 'Fill out notice form' do
      fill_in 'notice_title', with: notice.title
      fill_in 'notice_description', with: notice.description
      find(:css, '#notice_public').set(notice.public)
      fill_in 'notice[d_publish]', with: notice.d_publish
      fill_in 'notice[d_remove]', with: notice.d_remove
      fill_in 'notice_sort', with: notice.sort
      find('#submit-notice').click
    end

    And 'Assure notice is created' do
      page.should have_css('div.alert.alert-info')
      find('div.alert.alert-info').text.should \
       include(%(#{I18n.t(:notice)} #{I18n.t(:success_create)}))
    end
  end
end
