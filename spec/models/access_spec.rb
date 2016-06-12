require 'rails_helper'

RSpec.describe Access, type: :model do
  it 'has valid factory' do
    build_stubbed(:access).should be_valid
  end

  describe 'validations' do
    it { Access.new.should validate_presence_of(:door) }
    it { Access.new.should validate_presence_of(:post) }
    it 'checks uniqueness of door and post' do
      door = create(:door)
      post = create(:post)

      Access.new(door: door, post: post).should be_valid
      create(:access, door: door, post: post)
      Access.new(door: door, post: post).should be_invalid
    end
  end
end
