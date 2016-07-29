require 'rails_helper'

RSpec.describe Candidate, type: :model do
  it 'has a valid factory' do
    build(:candidate).should be_valid
  end

  describe 'validations' do
    it 'validates uniqueness of position to user and eleciton' do
      election = create(:election, :autumn)
      position = create(:position, :autumn)
      user = create(:user)
      cand = build(:candidate, election: election, position: position, user: user)

      cand.should be_valid
      cand.save!

      new_cand = build(:candidate, election: election, position: position, user: user)
      new_cand.should be_invalid
      new_cand.errors[:position].should include(I18n.t('model.candidate.similar_candidate'))
    end

    it { Candidate.new.should validate_presence_of(:election) }
    it { Candidate.new.should validate_presence_of(:user) }
    it { Candidate.new.should validate_presence_of(:position) }

    it 'invalid if wrong semester on position and election' do
      election = create(:election, :autumn)
      position = create(:position, :spring)
      cand = build_stubbed(:candidate, position: position, election: election)

      cand.valid?.should be_falsey
    end
  end

  describe 'associations' do
    # Associations
    it { Candidate.new.should belong_to(:election) }
    it { Candidate.new.should belong_to(:position) }
    it { Candidate.new.should belong_to(:user) }
  end

  describe 'public methods' do
    it 'is editable?' do
      # candidates elected by General meeting is only editable :before_general
      election = create(:election, :before_general, :autumn)

      position = create(:position, :general, :autumn)
      candidate = build(:candidate, position: position, election: election)

      candidate.editable?.should be_truthy
    end

    it 'is not editable' do
      # candidates elected by General meeting is only editable :before_general,
      # not :after_general
      election = create(:election, :after_general, :autumn)
      position = create(:position, :general, :autumn)
      candidate = build(:candidate, position: position, election: election)

      candidate.editable?.should be_falsey
    end
  end
end
