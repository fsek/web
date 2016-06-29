require 'rails_helper'
RSpec.feature 'Pages' do
  it 'visits as normal user' do
    user = create(:user)
    page_object = create(:page, visible: true, public: true, title: 'Motioner')
    create(:page_element, :text, page: page_object, visible: true)
    create(:page_element, :image, page: page_object, visible: true)

    sign_in_as(user, path: page_path(page_object))
    page.status_code.should eq(200)
    find('.headline h1').text.should eq('Motioner')
    page.should_not have_css('.col-md-12 a.pull-right')
  end
end
