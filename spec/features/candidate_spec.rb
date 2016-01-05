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
    allow(Election).to receive(:current) { election }
  end

  Steps 'Create a candidate' do
    Then 'Sign in' do
      login.visit_page.login(user, '12345678')
    end

    When 'I try to see the page' do
      test_post.reload
      page.visit new_candidate_path
    end

    And 'I fill out form' do
      page.status_code.should eq(200)
      select(test_post, from: 'candidate_post_id')
      select(user, from: 'candidate_user_id')
    end

    And 'I submit form' do
      find('#candidate-submit').click
    end

    Then 'I see status updated' do
      page.should have_css('div.alert.alert-info')
      find('div.alert.alert-info').text.should include(I18n.t(:success_create))
    end
  end
end
