require 'rails_helper'

RSpec.describe Constant, type: :model do
  subject(:constant) { FactoryGirl.build(:constant) }
  describe :Validations do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:value) }
    it { should validate_uniqueness_of(:name) }
  end

  it 'can return value by calling the get() function' do
    Constant.create(name: 'foo', value: 'bar')
    val = Constant.get 'foo'
    expect(val).to eq('bar')
  end
end