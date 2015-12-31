require 'rails_helper'
RSpec.feature 'Confirm account' do
  let(:user) { create(:user, :unconfirmed) }

  scenario 'confirm' do
    page.visit(user_confirmation_url(confirmation_token: user.confirmation_token))
    page.status_code.should eq(200)

    find('div.alert.alert-info').text.should include(I18n.t('devise.confirmations.confirmed'))
    user.reload.confirmed?.should be_truthy
  end
end
