require 'rails_helper'

RSpec.describe Notification, type: :model do
  it 'has valid factory' do
    build_stubbed(:notification, :build_stubbed).should be_valid
  end
end
