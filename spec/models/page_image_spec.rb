require 'rails_helper'

RSpec.describe PageImage, type: :model do
  it 'has a valid factory' do
    build_stubbed(:page_image).should be_valid
  end

  describe 'ActiveRecord associations' do
    it 'validates image and page_id present' do
      PageImage.new.should validate_presence_of(:page)
      PageImage.new.should validate_presence_of(:image)
    end
  end

  describe 'public methods' do
    it 'has valid to_s' do
      build_stubbed(:page_image, id: 1337).to_s.should eq(1337)
    end
  end
end
