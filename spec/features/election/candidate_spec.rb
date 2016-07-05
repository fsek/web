require 'rails_helper'
RSpec.feature 'Visit Election', type: :feature do
  scenario 'creates a candidate' do
    user = create(:user)
    create(:election, :autumn)
    position = create(:position, :autumn)

    sign_in_as(user, path: candidates_path)
    find(:linkhref, new_candidate_path).click

    page.status_code.should eq(200)
    select(position, from: 'candidate_position_id')
    select(user, from: 'candidate_user_id')
    find('#candidate-submit').click

    page.should have_css('div.alert.alert-info')
    find('div.alert.alert-info').text.should include(I18n.t('global_controller.success_create'))
  end
end
