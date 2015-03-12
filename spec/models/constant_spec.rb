require 'rails_helper'

RSpec.describe Constant, type: :model do
  it 'fails validation with no name' do
    c = Constant.new(value: 'foo')
    c.valid?
    expect(c.errors[:name]).to include('måste anges')
  end
  it 'fails validation with no value' do
    c = Constant.new(name: 'foo')
    c.valid?
    expect(c.errors[:value]).to include('måste anges')
  end
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
