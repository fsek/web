require 'spec_helper'

feature 'User goes to the home page' do
  scenario 'They see "F-sektionen" on the page' do
    visit '/'
    expect(page).to have_content('F-sektionen')
    page.status_code.should eq(200)
  end
end
