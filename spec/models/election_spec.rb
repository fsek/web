require 'rails_helper'

RSpec.describe Election, type: :model do
  it 'has a valid factory' do
    build(:election).should be_valid
  end

  # Lazily loaded to ensure it's only used when it's needed
  subject() { build(:election) }
  let(:election) { create(:election) }

  statuses = %w(:before :during :after :closed)
  describe 'ActiveModel validations' do
    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:start) }
    it { should validate_presence_of(:end) }
  end

  describe 'ActiveRecord associations' do
    it { should have_many(:nominations) }
    it { should have_many(:candidates) }
    it { should have_and_belong_to_many(:posts) }
  end

  context 'callbacks' do
    describe 'public instance methods' do
      context 'responds to its methods' do
        it { election.should respond_to(:termin_grid) }
        it { election.should respond_to(:rest_grid) }
        it { election.should respond_to(:view_status) }
        it { election.should respond_to(:status_text) }
        it { election.should respond_to(:nomination_status) }
        it { election.should respond_to(:current_posts) }
        it { election.should respond_to(:countdown) }
        it { election.should respond_to(:candidate_count) }
        it { election.should respond_to(:can_candidate?) }
        it { election.should respond_to(:to_param) }
      end
    end

    describe 'check that methods are correct' do
      context 'view_status' do
        e = create(:election, :before)
        e.view_status.should equal(:before)
      end
    end
  end
end
