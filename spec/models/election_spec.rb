require 'rails_helper'

RSpec.describe Election, type: :model do
  it 'has a valid factory' do
    build(:election).should be_valid
  end

  # Lazily loaded to ensure it's only used when it's needed
  subject { build(:election) }
  let(:election) { create(:election) }

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
        it { election.should respond_to(:state) }
        it { election.should respond_to(:current_posts) }
        it { election.should respond_to(:countdown) }
        it { election.should respond_to(:candidate_count) }
        it { election.should respond_to(:can_candidate?) }
        it { election.should respond_to(:to_param) }
      end
    end

    describe 'check that methods are correct' do
      context 'state' do
        it :before do
          e = create(:election, :before)
          e.state.should equal(:before)
        end

        it :during do
          e = create(:election, :during)
          e.state.should equal(:during)
        end

        it :after do
          e = create(:election, :after)
          e.state.should equal(:after)
        end

        it :closed do
          e = create(:election, :closed)
          e.state.should equal(:closed)
        end
      end
    end
  end
end
