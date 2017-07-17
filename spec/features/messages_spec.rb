require 'rails_helper'

RSpec.feature 'Send messages', type: :feature do
  it 'sends messsage' do
    user = create(:user)
    group = create(:group)
    group.users << user

    sign_in_as(user, path: group_path(group))
    page.status_code.should eq(200)

    page.fill_in('message_content', with: 'Hej och välkomna, liksom waow')
  end
end
