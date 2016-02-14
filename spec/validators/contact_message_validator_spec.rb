require 'rails_helper'

RSpec.describe ContactMessageValidator do
  it 'valid params' do
    message = build(:contact_message, name: 'David',
                                      email: 'david@google.com')

    message.validate!.should be_truthy
    message.name.should eq('David')
  end

  it 'invalid email' do
    message = build(:contact_message, name: 'David',
                                      email: 'david@')

    message.validate!.should be_falsey
    message.errors[:email].present?.should be_truthy
  end

  it 'blank name' do
    message = build(:contact_message, name: '',
                                      email: 'david@google.se')

    message.validate!.should be_falsey
    message.errors[:name].present?.should be_truthy
  end

  it 'blank email' do
    message = build(:contact_message, name: 'David',
                                      email: '')

    message.validate!.should be_falsey
    message.errors[:email].present?.should be_truthy
  end
end
