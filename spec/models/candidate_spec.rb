require 'rails_helper'

RSpec.describe Candidate, type: :model do
  it 'has a valid factory' do
    build(:candidate).should be_valid
  end

  subject(:cand) { build_stubbed(:candidate) }
  let(:saved) { create(:candidate) }

  describe 'validations' do
    it 'validates uniqueness of post to user and eleciton' do
      election = create(:election, semester: Post::AUTUMN)
      postt = create(:post, semester: Post::AUTUMN)
      user = build_stubbed(:user)
      cand = build(:candidate, election: election, post: postt, user: user)

      cand.should validate_uniqueness_of(:post_id).
        scoped_to(:user_id, :election_id).
        with_message(I18n.t('candidate.similar_candidate'))

      cand.should validate_presence_of(:election)
      cand.should validate_presence_of(:user)
      cand.should validate_presence_of(:post)
    end

    it 'invalid if wrong semester on post and election' do
      election = create(:election, semester: Post::AUTUMN)
      postt = create(:post, semester: Post::SPRING)
      cand = build_stubbed(:candidate, post: postt, election: election)

      cand.valid?.should be_falsey
    end
  end


  describe 'associations' do
    # Associations
    it { should belong_to(:election) }
    it { should belong_to(:post) }
    it { should belong_to(:user) }
  end

  context 'callbacks' do
    describe 'public instance methods' do
      it 'is editable?' do
        # candidates elected by General meeting is only editable :during the
        # election
        election = build_stubbed(:election, :during)
        election.state.should eq(:during)

        postt = build_stubbed(:post, elected_by: Post::GENERAL)
        candidate = build_stubbed(:candidate, post: postt, election: election)

        candidate.editable?.should be_truthy
      end

      it 'is not editable' do
        # candidates elected by General meeting is only editable :during the
        # election, not :after
        election = build_stubbed(:election, :after)
        election.state.should eq(:after)

        postt = build_stubbed(:post, elected_by: Post::GENERAL)
        candidate = build_stubbed(:candidate, post: postt, election: election)

        candidate.editable?.should be_falsey
      end

      context 'responds to its methods' do
        it { saved.should respond_to(:editable?) }
        it { saved.should respond_to(:p_url) }
        it { saved.should respond_to(:owner?) }
      end
    end
  end
end
