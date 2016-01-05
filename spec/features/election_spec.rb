require 'rails_helper'
RSpec.feature 'Visit Election' do
  let(:user) { create(:user) }
  let(:election) { create(:election) }
  let(:council) { create(:council) }
  let(:the_post) { create(:post, council: council, elected_by: 'Terminsmötet') }
  background do
    council
    the_post
    election.posts << the_post
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
end
