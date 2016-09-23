require 'rails_helper'

RSpec.describe Category, type: :model do
  it 'has valid factory' do
    build(:category).should be_valid
  end

  it 'to param' do
    category = build_stubbed(:category, slug: 'categorieees_url')
    category.to_param.should eq('categorieees_url')
  end

  it 'allows use_case' do
    category = build_stubbed(:category)
    category.should be_valid

    category.use_case = 'invalid_use_case'
    category.should be_invalid
    category.errors[:use_case].should include(I18n.t('model.category.not_allowed_use_case'))

    category.use_case = Category::USE_CASES.last
    category.should be_valid
    category.errors[:use_case].should_not include(I18n.t('model.category.not_allowed_use_case'))
  end

  it 'checks if use case is allowed' do
    category = Category.new(use_case: Category::GENERAL)
    category.allowed_use_case?('whatever').should be_truthy

    category.use_case = 'BlogPost'
    category.allowed_use_case?('whatever').should be_falsey
    category.allowed_use_case?('BlogPost').should be_truthy
  end
end
