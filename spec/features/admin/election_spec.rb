require 'rails_helper'
RSpec.feature 'Admin visit election:' do
  let(:user) { create(:admin) }
  let(:login) { LoginPage.new }

  scenario 'index' do
    election = create(:election)
    postt = create(:post)
    election.posts << postt

    login_as(user)
    page.visit admin_elections_path
    page.status_code.should eq(200)
  end

  scenario 'show' do
    election = create(:election)
    election.posts << create(:post)

    login_as(user)
    page.visit admin_elections_path
    first(:linkhref, admin_election_path(election)).click
    page.status_code.should eq(200)
  end

  scenario 'edit' do
    election = create(:election)

    login_as(user)
    page.visit admin_election_path(election)
    first(:linkhref, edit_admin_election_path(election)).click
    page.status_code.should eq(200)
  end

  scenario 'nominations' do
    election = create(:election)
    create(:nomination, election: election)

    login_as(user)
    page.visit admin_election_path(election)
    first(:linkhref, nominations_admin_election_path(election)).click
    page.status_code.should eq(200)
  end

  scenario 'candidates' do
    election = create(:election)
    postt = create(:post)
    election.posts << postt
    create(:candidate, post: postt, election: election)

    login_as(user)
    page.visit admin_election_path(election)
    first(:linkhref, candidates_admin_election_path(election)).click
    page.status_code.should eq(200)
  end

  private

  def login_as(user)
    login.visit_page.login(user, '12345678')
  end
end
