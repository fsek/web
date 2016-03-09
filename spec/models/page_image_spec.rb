require 'rails_helper'

RSpec.describe PageImage, type: :model do
  it 'has a valid factory' do
    build(:page_image).should be_valid
  end

  describe 'ActiveRecord associations' do
    it 'validates image and page_id present' do
      page_image = build(:page_image)
      page_image.should validate_presence_of(:page_id)
      page_image.should validate_presence_of(:image)
    end
  end

  describe 'public methods' do
    it 'has valid to_s' do
      page_image = build_stubbed(:page_image, id: 1337)
      page_image.to_s.should eq(1337)
    end
  end
end
