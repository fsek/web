require 'rails_helper'

RSpec.describe Constant, type: :model do
  subject(:constant) { build(:constant) }
  describe :Validations do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:value) }
    it { should validate_uniqueness_of(:name) }
  end

  it 'is valid with a name and a value' do
    c = Constant.new(name: 'foo', value: 'bar')
    c.should be_valid
  end

  it 'can return value by calling the get() function' do
    Constant.create(name: 'foo', value: 'bar')
    val = Constant.get 'foo'
    val.should eq('bar')
  end
end
