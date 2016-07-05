require 'rails_helper'

RSpec.describe Election, type: :model do
  subject { build_stubbed(:election) }
  it 'has a valid factory' do
    should be_valid
  end

  describe 'ActiveModel validations' do
    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:open) }
    it { should validate_presence_of(:close_general) }
    it { should validate_presence_of(:close_all) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:semester) }

    it 'validates url format' do
      should validate_presence_of(:url)
      should allow_value('abc-123').for(:url)
      should_not allow_value('ABC').for(:url)
    end
  end

  describe 'ActiveRecord associations' do
    it { should have_many(:nominations) }
    it { should have_many(:candidates) }
    it { should have_many(:extra_positions) }
  end

  describe '#state' do
    it :not_opened do
      e = build_stubbed(:election, :not_opened)
      e.state.should equal(:not_opened)
    end

    it :before_general do
      e = build_stubbed(:election, :before_general)
      e.state.should equal(:before_general)
    end

    it :after_general do
      e = build_stubbed(:election, :after_general)
      e.state.should equal(:after_general)
    end

    it :closed do
      e = build_stubbed(:election, :closed)
      e.state.should equal(:closed)
    end
  end

  describe '#position_closing' do
    it 'returns close_general for position elected at general' do
      close_general = 1.day.ago
      close_all = 1.day.from_now
      election = build_stubbed(:election, :autumn,
                               close_general: close_general,
                               close_all: close_all)
      general_position = build_stubbed(:position, :autumn, :general)
      after_general_position = build_stubbed(:position, :autumn, :board)

      election.position_closing(general_position).should eq(close_general)
      election.position_closing(after_general_position).should eq(close_all)
    end
  end

  describe '#countdown' do
    it 'returns countdowns for different states' do
      open = 5.days.ago
      close_general = 3.days.ago
      close_all = 2.days.from_now
      election = build_stubbed(:election, open: open,
                                          close_general: close_general,
                                          close_all: close_all)
      election.stub(:state).and_return(:not_opened)
      election.countdown.should eq(open)

      election.stub(:state).and_return(:before_general)
      election.countdown.should eq(close_general)

      election.stub(:state).and_return(:after_general)
      election.countdown.should eq(close_all)

      election.stub(:state).and_return(:closed)
      election.countdown.should be_nil
    end
  end

  context 'position queries' do
    describe '#positions' do
      it 'returns according to semester' do
        election = create(:election)
        create(:position, :autumn, title: 'In the Autumn')
        create(:position, :spring, title: 'In the Spring')
        election.extra_positions << create(:position, semester: 'not_by_semester',
                                              title: 'An extra one')

        election.stub(:semester).and_return(Position::AUTUMN)
        election.positions.map(&:title).should eq(['In the Autumn'])

        election.stub(:semester).and_return(Position::SPRING)
        election.positions.map(&:title).should eq(['In the Spring'])

        election.stub(:semester).and_return(Position::OTHER)
        election.positions.map(&:title).should eq(['An extra one'])
      end
    end

    describe '#current_positions' do
      it 'returns according to state' do
        election = create(:election, :autumn)
        create(:position, :autumn, :general, title: 'Elected at General')
        create(:position, :autumn, :board, title: 'Elected by Board')

        election.stub(:state).and_return(:not_opened)
        election.current_positions.map(&:title).should eq(['Elected at General',
                                                       'Elected by Board'])

        election.stub(:state).and_return(:before_general)
        election.current_positions.map(&:title).should eq(['Elected at General',
                                                       'Elected by Board'])

        election.stub(:state).and_return(:after_general)
        election.current_positions.map(&:title).should eq(['Elected by Board'])

        election.stub(:state).and_return(:closed)
        election.current_positions.map(&:title).should eq([])
      end
    end

    describe '#searchable_positions' do
      it 'returns according to state' do
        election = build_stubbed(:election)
        election.stub(:current_positions).and_return('yeppyepp')

        election.stub(:state).and_return(:not_opened)
        election.searchable_positions.should eq(Position.none)

        election.stub(:state).and_return(:closed)
        election.searchable_positions.should eq(Position.none)

        election.stub(:state).and_return(:before_general)
        election.searchable_positions.should eq('yeppyepp')

        election.stub(:state).and_return(:after_general)
        election.searchable_positions.should eq('yeppyepp')
      end
    end
  end
end
