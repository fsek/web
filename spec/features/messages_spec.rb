require 'rails_helper'

RSpec.feature 'Send messages', type: :feature do
  it 'sends messsage' do
    user = create(:user)
    group = create(:group)
    group.users << user

    sign_in_as(user, path: new_group_message_path(group))
    page.status_code.should eq(200)

    page.fill_in('wmd-input-content', with: 'Hej och välkomna, liksom waow')
    find('input[name="commit"]').click

    page.should have_http_status(200)
    page.should have_css('div.alert.alert-info')
    find('div.alert.alert-info').text.should include(I18n.t('global_controller.success_create'))
  end
end
