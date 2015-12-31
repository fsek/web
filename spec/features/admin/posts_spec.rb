require 'rails_helper'
RSpec.feature 'Admin Visit Posts' do
  let(:user) { create(:admin) }
  let(:council) { create(:council) }
  let(:test_post) do
    create(:post, council: council, elected_by: 'Terminsmötet')
  end
  let(:login) { LoginPage.new }

  background do
    user
    council
    test_post
  end

  Steps 'Checking out posts' do
    And 'Signing in' do
      login.visit_page.login(user, '12345678')
    end

    When 'I visit council' do
      page.visit edit_council_path(council)
    end

    Then 'I see edit council headline' do
      page.status_code.should eq(200)
      first('div.headline h3').text.should include(I18n.t(:edit, attr: nil))
    end

    And 'I visit councils posts' do
      first(:linkhref, council_posts_path(council)).click
    end

    Then 'I see post page' do
      page.status_code.should eq(200)
    end

    And 'I edit a post' do
      first(:linkhref, edit_council_post_path(council, test_post)).click
    end

    Then 'I see edit post page' do
      page.status_code.should eq(200)
      first('div.headline > h2').text.should include(I18n.t(:edit, attr: nil))
    end
  end
end
