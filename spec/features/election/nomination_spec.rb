require 'rails_helper'
RSpec.feature 'Visit Election' do
  scenario 'nominating successfully' do
    user = create(:user)
    election = create(:election)
    the_post = create(:post)
    election.posts << the_post
    sign_in_as(user, path: new_nominations_path)

    fill_in 'nomination_name', with: 'David Wessman'
    fill_in 'nomination_email', with: 'd.wessman@fsektionen.se'
    select(the_post, from: 'nomination_post_id')
    fill_in 'nomination_motivation', with: 'Foo'

    find('#nomination-submit').click

    page.status_code.should eq(200)
    page.should have_css('div.alert.alert-info')
    find('div.alert.alert-info').text.should include(I18n.t('global_controller.success_create'))
  end
end
