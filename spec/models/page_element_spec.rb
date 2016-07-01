require 'rails_helper'

RSpec.describe PageElement, type: :model do
  it 'has a valid factory' do
    build(:page_element).should be_valid
  end

  describe 'ActiveRecord associations' do
    it 'validates element_type and page_id present' do
      page_element = build(:page_element)
      page_element.should validate_presence_of(:page)
      page_element.should validate_presence_of(:element_type)
    end
  end

  describe 'public methods' do
    it 'has valid to_s' do
      page_element = build_stubbed(:page_element, id: 1337, headline: 'Cool')
      page_element.to_s.should eq('Cool')

      page_element.headline = nil
      page_element.to_s.should eq(1337)
    end

    it 'gives the right partial path if image' do
      page_element = build_stubbed(:page_element, element_type: PageElement::IMAGE)

      page_element.to_partial_path.should eq('/pages/image_element')
    end

    it 'gives the right partial path if text' do
      page_element = build_stubbed(:page_element, element_type: PageElement::TEXT)

      page_element.to_partial_path.should eq('/pages/text_element')
    end
  end
end
