require 'rails_helper'
RSpec.feature 'Admin Visit Posts' do
  Steps 'Checking out posts' do
    user = create(:admin)
    council = create(:council)
    postt = create(:post, council: council)

    And 'Signing in' do
      LoginPage.new.visit_page.login(user, '12345678')
    end

    When 'I visit council' do
      page.visit edit_admin_council_path(council)
    end

    Then 'I see edit council headline' do
      page.status_code.should eq(200)
      first('div.headline h1').text.should include(I18n.t('council.edit'))
    end

    And 'I visit councils posts' do
      first(:linkhref, admin_council_posts_path(council)).click
    end

    Then 'I see post page' do
      page.status_code.should eq(200)
    end

    And 'I edit a post' do
      first(:linkhref, edit_admin_council_post_path(council, postt)).click
    end

    Then 'I see edit post page' do
      page.status_code.should eq(200)
      first('div.headline > h1').text.should include(I18n.t('post.edit'))
    end
  end
end
