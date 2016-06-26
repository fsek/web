require 'rails_helper'
RSpec.feature 'Visit Election' do
  scenario 'visits during election' do
    postt = create(:post)
    election = create(:election)
    election.posts << postt

    page.visit elections_path
    page.status_code.should eq(200)
    page.should have_css('h1#election-title')
    find('h1#election-title').text.should include(election.title)
  end

  scenario 'visits after election' do
    postt = create(:post)
    election = create(:election, end: 1.hour.ago)
    election.posts << postt

    page.visit elections_path
    page.status_code.should eq(200)
    page.should have_css('h1#election-title')
    find('h1#election-title').text.should include(election.title)
  end

  scenario 'visits after election is closed' do
    postt = create(:post)
    election = create(:election, end: 1.hour.ago, closing: 1.minute.ago)
    election.posts << postt

    page.visit elections_path
    page.status_code.should eq(200)
    page.should have_css('h1#election-title')
    find('h1#election-title').text.should include(election.title)
  end
end
