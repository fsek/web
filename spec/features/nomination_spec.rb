require 'rails_helper'
RSpec.feature 'Visit Election' do
  let(:user) { create(:user) }
  let(:login) { LoginPage.new }

  Steps 'Trying nomination page' do
    postt = create(:post, semester: Post::AUTUMN)
    create(:election, semester: Post::AUTUMN)

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
      select(postt, from: 'nomination_post_id')
      fill_in 'nomination_motivation', with: 'Foo'
    end

    And 'I submit form' do
      find('#nomination-submit').click
    end

    Then 'I see confirmation' do
      page.status_code.should eq(200)
      page.should have_css('div.alert.alert-info')
      find('div.alert.alert-info').text.should include(I18n.t(:success_create))
    end
  end
end
