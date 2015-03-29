require 'rails_helper'

RSpec.describe Constant, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:name) }
  it 'is valid with a name and a value' do
    c = Constant.new(name: 'foo', value: 'bar')
    expect(c).to be_valid
  end
  it 'can return value by calling the get() function' do
    Constant.create(name: 'foo', value: 'bar')
    val = Constant.get 'foo'
    expect(val).to eq('bar')
  end
end
