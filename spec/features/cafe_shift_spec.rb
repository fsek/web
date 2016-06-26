require 'rails_helper'
RSpec.feature 'Visit cafe', type: :feature do
  scenario 'sign up to work' do
    user = create(:user)
    cafe_shift = create(:cafe_shift)

    sign_in_as(user, path: cafe_shift_path(cafe_shift))

    check 'cafe_worker_competition'
    click_button I18n.t('helpers.submit.cafe_worker.create')
    page.should have_css('div.alert.alert-info')
    find('div.alert.alert-info').text.should include(I18n.t('model.cafe_worker.created'))

    cafe_shift.reload
    cafe_shift.cafe_worker.user.should eq(user)
  end
end
