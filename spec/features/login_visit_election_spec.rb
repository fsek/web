require 'rails_helper'
#feature 'Visit Election', js: true do
feature 'Visit Election' do
  let(:user) { create(:user) }
  let(:election) { create(:election) }
  let(:council) { create(:council) }
  let(:post) { create(:post, council: council, elected_by: 'Terminsmötet') }
  background do
    council
    post
    election
    allow(election).to receive(:current_posts) { Post.all }
  end

  Steps 'Visit the election page' do
    When 'visit the page' do
      page.visit elections_path
    end
    Then 'I should see greeting' do
      page.should have_css('h1#election-title')
      find('h1#election-title').text.should include(election.title)
    end
  end
  Steps 'Trying nominations page' do
    When 'I try to see the page' do
      page.visit new_nominations_path
    end
    Then 'I see alert' do
      page.should have_css('div.alert-danger')
      find('div.alert-danger').text.should include(I18n.t('unauthorized.new.nomination'))
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
    And 'Visit page again' do
      page.visit new_nominations_path
    end
    Then 'There should be headline' do
      find('h1').text.should include('Nominering')
    end
    And 'I fill out form' do
      fill_in 'nomination_name', with: 'David Wessman'
      fill_in 'nomination_email', with: 'd.wessman@fsektionen.se'
      # This is driving me crazy.
      #select(post.id, from: 'nomination_post_id')
      fill_in 'nomination_motivation', with: 'Foo'
    end
    And 'I submit form' do
      find('#nomination-submit').click
    end
    Then 'I see status updated', pending: true  do
      # I cannot get this to work, the js shit.
      # David W, 2015-04-11
      page.should have_css('div#status')
      find('div#status').text.should include()
    end
  end
end
