require 'rails_helper'
RSpec.feature 'Visit Election' do
  scenario 'visits election before_general' do
    create(:post, :autumn)
    election = create(:election, :before_general, :autumn)

    page.visit elections_path
    page.should have_http_status(200)
    page.should have_css('h1#election-title')
    find('h1#election-title').text.should include(election.title)
  end

  scenario 'visits election after_general' do
    create(:post, :autumn)
    election = create(:election, :after_general, :autumn)

    page.visit elections_path
    page.should have_http_status(200)
    page.should have_css('h1#election-title')
    find('h1#election-title').text.should include(election.title)
  end

  scenario 'visits election closed' do
    create(:post, :autumn)
    election = create(:election, :closed, :autumn)

    page.visit elections_path
    page.should have_http_status(200)
    page.should have_css('h1#election-title')
    find('h1#election-title').text.should include(election.title)
  end
end
