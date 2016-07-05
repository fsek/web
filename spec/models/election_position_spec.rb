require 'rails_helper'

RSpec.describe ElectionPosition, type: :model do
  it 'has a valid factory' do
    build_stubbed(:election_position).should be_valid
  end
  subject { ElectionPosition.new }

  it { should belong_to(:election) }
  it { should belong_to(:position) }

  it { should validate_presence_of(:election) }
  it { should validate_presence_of(:position) }

  it 'validates uniqueness of position and election' do
    position = create(:position)
    election = create(:election)

    election_position = ElectionPosition.new(position: position, election: election)
    election_position.should be_valid

    election_position.save!
    ElectionPosition.new(position: position, election: election).should be_invalid
  end
end
