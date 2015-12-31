require 'rails_helper'

RSpec.feature 'User goes to the home page' do
  let(:news1) { create(:news) }
  let(:news2) { create(:news) }
  let(:news3) { create(:news) }

  before do
    news1
    news2
    news3
  end

  scenario 'They see "F-sektionen" on the page' do
    visit root_path
    page.should have_content('F-sektionen')
    page.status_code.should eq(200)
  end
end
