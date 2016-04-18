require 'rails_helper'
RSpec.feature 'Admin edit pages' do
  let(:user) { create(:admin) }
  let(:login) { LoginPage.new }

  scenario 'index and edit' do
    test_page = create(:page)
    create(:page)
    create(:page)

    login_as(user)
    page.visit admin_pages_path
    page.status_code.should eq(200)

    first(:linkhref, edit_admin_page_path(test_page)).click
    page.status_code.should eq(200)
  end

  scenario 'page_element index' do
    test_page = create(:page_with_elements)

    login_as(user)
    page.visit admin_page_page_elements_path(test_page)
    page.status_code.should eq(200)
  end

  scenario 'page_element new edit' do
    test_page = create(:page_with_elements)
    element = test_page.page_elements.first

    login_as(user)
    page.visit new_admin_page_page_element_path(test_page)
    page.status_code.should eq(200)

    page.visit edit_admin_page_page_element_path(test_page, element)
    page.status_code.should eq(200)
  end

  private

  def login_as(user)
    login.visit_page.login(user, '12345678')
  end
end
