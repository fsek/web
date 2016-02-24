require 'rails_helper'
RSpec.feature 'Visit Election' do
  let(:user) { create(:user) }
  let(:login) { LoginPage.new }

  Steps 'Create a candidate' do
    election = create(:election)
    postt = create(:post, semester: Post::AUTUMN)
    election.posts << postt

    Then 'Sign in' do
      login.visit_page.login(user, '12345678')
    end

    When 'I try to see the page' do
      page.visit candidates_path
    end

    When 'I try to see the page' do
      page.visit new_candidate_path
    end

    And 'I fill out form' do
      page.status_code.should eq(200)
      select(postt, from: 'candidate_post_id')
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
