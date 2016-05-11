require 'rails_helper'

RSpec.describe Candidate, type: :model do
  it 'has a valid factory' do
    build(:candidate).should be_valid
  end

  describe 'ActiveModel validations' do
    # Basic validations
    it do
      Candidate.new.should validate_uniqueness_of(:post_id).
        scoped_to(:user_id, :election_id).
        with_message(I18n.t('model.candidate.similar_candidate')).
        on(:create)
    end
  end

  it { Candidate.new.should validate_presence_of(:election) }
  it { Candidate.new.should validate_presence_of(:user) }
  it { Candidate.new.should validate_presence_of(:post) }

  describe 'ActiveRecord associations' do
    # Associations
    it { Candidate.new.should belong_to(:election) }
    it { Candidate.new.should belong_to(:post) }
    it { Candidate.new.should belong_to(:user) }
  end

  context 'callbacks' do
    describe 'public instance methods' do
      context 'responds to its methods' do
        it { Candidate.new.should respond_to(:editable?) }
        it { Candidate.new.should respond_to(:p_url) }
        it { Candidate.new.should respond_to(:owner?) }
      end
    end
  end
end
