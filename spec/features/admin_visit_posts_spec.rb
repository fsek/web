require 'rails_helper'
feature 'Admin Visit Posts' do
  let(:user) { create(:admin) }
  let(:council) { create(:council) }
  let(:post) { create(:post, council: council, elected_by: 'Terminsmötet') }
  background do
    user
    council
    post
  end

  Steps 'Checking out posts' do
    When 'visit the page' do
      page.visit new_user_session_path
    end
    And 'I sign in' do
      page.fill_in 'user_username', with: user.username
      page.fill_in 'user_password', with: '12345678'
      page.click_button I18n.t('devise.sign_in')
    end
    Then 'I see logged in alert' do
      page.should have_css('div.alert.alert-info')
      find('div.alert.alert-info').text.should include(I18n.t('devise.sessions.signed_in'))
    end
    When 'I visit council' do
      page.visit edit_council_path(council)
    end
    Then 'I see edit council headline' do
      find('label.reg-header').text.should include('Redigera utskott')
    end
    And 'I visit councils posts' do
      find(:linkhref, council_posts_path(council)).click
    end
    Then 'I see post page' do
      page.status_code.should == 200
    end
    And 'I edit a post' do
      first(:linkhref, edit_council_post_path(council, post)).click
    end
    Then 'I see edit post page' do
      page.status_code.should == 200
      find('label.reg-header').text.should include('Redigera post')
    end
  end
end
