require 'rails_helper'
RSpec.feature 'Visit Election' do

  Steps 'Visit the election page' do
    create(:post, semester: Post::AUTUMN)
    election = create(:election, semester: Post::AUTUMN)

    When 'visit the page' do
      page.visit elections_path
    end

    Then 'I should see greeting' do
      page.should have_css('h2#election-title')
      find('h2#election-title').text.should include(election.title)
    end
  end
end
