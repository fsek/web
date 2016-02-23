require 'rails_helper'

RSpec.describe Candidate, type: :model do
  it 'has a valid factory' do
    build(:candidate).should be_valid
  end

  # Lazily loaded to ensure it's only used when it's needed
  subject(:cand) { build(:candidate) }
  let(:saved) { create(:candidate) }

  describe 'ActiveModel validations' do
    # Basic validations
    it do
      cand.should validate_uniqueness_of(:post_id).
        scoped_to(:user_id, :election_id).
        with_message(I18n.t('candidate.similar_candidate')).
        on(:create)
    end
  end

  it { should validate_presence_of(:election) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:post) }

  describe 'ActiveRecord associations' do
    # Associations
    it { should belong_to(:election) }
    it { should belong_to(:post) }
    it { should belong_to(:user) }
  end

  context 'callbacks' do
    describe 'public instance methods' do
      context 'responds to its methods' do
        it { saved.should respond_to(:editable?) }
        it { saved.should respond_to(:p_url) }
        it { saved.should respond_to(:owner?) }
      end
    end
  end
end
