require 'rails_helper'

RSpec.describe Category, type: :model do
  it 'has valid factory' do
    build(:category).should be_valid
  end

  it 'to param' do
    category = build_stubbed(:category, slug: 'categorieees_url')
    category.to_param.should eq('categorieees_url')
  end
end
