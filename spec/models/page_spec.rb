require 'rails_helper'

RSpec.describe Page, type: :model do
  it 'has a valid factory' do
    build(:page).should be_valid
  end

  describe 'validations' do
    it 'validates url' do
      page = build(:page, url: 'abc')
      page.should validate_presence_of(:url)
      page.should allow_value('abc_123-abc').for(:url)
      page.should_not allow_value('ABC').for(:url)
      page.should_not allow_value('https://illegal.com').for(:url)
    end
  end
end
