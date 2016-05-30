require 'rails_helper'
RSpec.feature 'Visit Election' do
  let(:user) { create(:user) }
  let(:election) do
    create(:election,
           start: Time.zone.now - 5.days,
           end: Time.zone.now + 2.days)
  end
  let(:council) { create(:council) }
  let(:test_post) { create(:post, council: council, elected_by: 'Terminsmötet') }
  let(:login) { LoginPage.new }

  background do
    council
    test_post
    election.posts << test_post
    allow(election).to receive(:current_posts) { Post.all }
  end

  Steps 'Trying nomination page' do
    Then 'Sign in' do
      login.visit_page.login(user, '12345678')
    end

    When 'I try to see the page' do
      page.visit new_nominations_path
      page.status_code.should eq(200)
    end

    And 'I fill out form' do
      fill_in 'nomination_name', with: 'David Wessman'
      fill_in 'nomination_email', with: 'd.wessman@fsektionen.se'
      select(test_post, from: 'nomination_post_id')
      fill_in 'nomination_motivation', with: 'Foo'
    end

    And 'I submit form' do
      find('#nomination-submit').click
    end

    Then 'I see confirmation' do
      page.status_code.should eq(200)
      page.should have_css('div.alert.alert-info')
      find('div.alert.alert-info').text.should include(I18n.t('global_controller.success_create'))
    end
  end
end
