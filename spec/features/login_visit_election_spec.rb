require 'rails_helper'
feature 'not logged in' do
  let(:user) { create(:user) }
  let(:election) { create(:election) }
  let(:council) { create(:council) }
  let(:post) { create(:post, council: council, elected_by: 'Terminsmötet') }
  before(:each) do
    allow(Election).to receive(:current).and_return(election)
  end
  before do
    election
    election.posts << post
  end
  scenario 'they try to visit election' do
    visit elections_path
    page.should have_css('h1#election-title')
    find('h1#election-title').text.should include(election.title)

    # Try nomination page
    visit new_nominations_path
    page.should have_css('div.alert-danger')
    find('div.alert-danger').text.should include(I18n.t('unauthorized.new.nomination'))
    fill_in 'user_username', with: user.username
    fill_in 'user_password', with: '12345678'
    click_button 'Logga in'
    page.should have_css('div.alert.alert-info') # Verify we get an alert
    find('div.alert.alert-info').text.should include(I18n.t('devise.sessions.signed_in'))


    visit new_nominations_path
    find('h1').text.should include('Nominering') # Verify that the alert states we are signed in


    fill_in 'nomination_name', with: 'David Wessman'
    fill_in 'nomination_email', with: 'd.wessman@fsektionen.se'
    select(post, from: 'nomination_post')
    fill_in 'nomination_motivation', with: 'Foo'
    find('#nomination-submit').click
    page.should have_css('div#status')
    find('div#status').text.should include() # Verify that the alert states we are signed in
  end
end
