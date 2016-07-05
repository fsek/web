require 'rails_helper'

RSpec.describe Access, type: :model do
  it 'has valid factory' do
    build_stubbed(:access).should be_valid
  end

  describe 'validations' do
    it { Access.new.should validate_presence_of(:door) }
    it { Access.new.should validate_presence_of(:position) }
    it 'checks uniqueness of door and position' do
      door = create(:door)
      position = create(:position)

      Access.new(door: door, position: position).should be_valid
      create(:access, door: door, position: position)
      Access.new(door: door, position: position).should be_invalid
    end
  end
end
