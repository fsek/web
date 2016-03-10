require 'rails_helper'

RSpec.feature 'News' do
  it 'visit index and show' do
    create(:news, title: 'First')
    create(:news, title: 'Second')
    create(:news, title: 'Third')
    with_image = create(:news, :with_image, title: 'Image')

    page.visit news_index_path
    page.status_code.should eq(200)

    find(:linkhref, news_path(with_image)).click
    page.status_code.should eq(200)
    find('.headline h1').text.should eq('Image')

    page.should have_css("img[src*='#{with_image.large}']")
  end
end
