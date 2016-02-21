require 'rails_helper'
RSpec.feature 'Visit Election' do

  Steps 'Visit the election page' do
    postt = create(:post)
    election = create(:election)
    election.posts << postt

    When 'visit the page' do
      page.visit elections_path
    end

    Then 'I should see greeting' do
      page.should have_css('h1#election-title')
      find('h1#election-title').text.should include(election.title)
    end
  end
end
