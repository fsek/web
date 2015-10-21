require 'rails_helper'
feature 'Admin visit election:' do
  let(:user) { create(:admin) }
  let(:election) { create(:election) }
  let(:council) { create(:council) }
  let(:the_post) { create(:post, council: council, elected_by: 'Terminsmötet') }
  let(:login) { LoginPage.new }

  background do
    council
    the_post
    election.posts << the_post
    create(:candidate, post: the_post, election: election)
    create(:nomination, post: the_post, election: election)
  end

  scenario 'index' do
    login_as(user)
    page.visit admin_elections_path
    page.status_code.should eq(200)
  end

  scenario 'show' do
    login_as(user)
    page.visit admin_elections_path
    first(:linkhref, admin_election_path(election)).click
    page.status_code.should eq(200)
  end

  scenario 'edit' do
    login_as(user)
    page.visit admin_election_path(election)
    first(:linkhref, edit_admin_election_path(election)).click
    page.status_code.should eq(200)
  end

  scenario 'nominations' do
    login_as(user)
    page.visit admin_election_path(election)
    first(:linkhref, nominations_admin_election_path(election)).click
    page.status_code.should eq(200)
  end

  scenario 'candidates' do
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
