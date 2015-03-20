require 'rails_helper'

RSpec.describe Candidate, type: :model do
  it 'has a valid factory' do
    expect(build(:candidate)).to be_valid
  end

  # Lazily loaded to ensure it's only used when it's needed
  let(:cand) { build(:candidate) }
  let(:saved) { create(:candidate) }

  describe 'ActiveModel validations' do
    # Basic validations
    it do
      val = validate_uniqueness_of(:profile_id).
        scoped_to(:post_id, :election_id).
        with_message('har redan en likadan kandidatur').
        on(:create)
      expect(cand).to val
    end
  end

  it { expect(cand).to validate_presence_of(:name) }
  it { expect(cand).to validate_presence_of(:lastname) }
  it { expect(cand).to validate_presence_of(:stil_id) }
  it { expect(cand).to validate_presence_of(:email) }
  it { expect(cand).to validate_presence_of(:phone) }
  it { expect(cand).to validate_presence_of(:election) }
  it { expect(cand).to validate_presence_of(:profile) }
  it { expect(cand).to validate_presence_of(:post).on(:create) }

  describe 'ActiveRecord associations' do
    # Associations
    it { expect(cand).to belong_to(:election) }
    it { expect(cand).to belong_to(:post) }
    it { expect(cand).to belong_to(:profile) }
  end

  context 'callbacks' do
    describe 'public instance methods' do
      context 'responds to its methods' do
        it { expect(saved).to respond_to(:send_email) }
        it { expect(saved).to respond_to(:prepare) }
        it { expect(saved).to respond_to(:editable?) }
        it { expect(saved).to respond_to(:p_url) }
        it { expect(saved).to respond_to(:owner?) }
      end
    end
  end
end
