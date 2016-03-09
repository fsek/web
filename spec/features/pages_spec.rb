require 'rails_helper'
RSpec.feature 'Pages' do
  it 'visits as normal user' do
    user = create(:user)
    LoginPage.new.visit_page.login(user, '12345678')
    page_object = create(:page, visible: true, public: true, title: 'Motioner')
    create(:page_element, :text, page: page_object, visible: true)
    create(:page_element, :image, page: page_object, visible: true)

    page.visit page_path(page_object)
    page.status_code.should eq(200)
    find('.headline h1').text.should eq('Motioner')
    page.should_not have_css('.col-md-12 a.pull-right')
  end

  it 'visits as normal user, without text and image' do
    user = create(:user)
    LoginPage.new.visit_page.login(user, '12345678')
    page_object = create(:page, visible: true, public: true, title: 'Motioner')
    first = create(:page_element, :text, page: page_object, visible: true)
    second = create(:page_element, :image, page: page_object, visible: true)

    first.update!(text: nil)
    second.update!(page_image: nil)

    page.visit page_path(page_object)
    page.status_code.should eq(200)
    find('.headline h1').text.should eq('Motioner')
  end
end
