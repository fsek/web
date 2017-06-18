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
      should allow_value('abc_123-abc').for(:url)
      should_not allow_value('ABC').for(:url)
    end
  end

  describe 'ActiveRecord associations' do
    it { should have_many(:nominations) }
    it { should have_many(:candidates) }
    it { should have_many(:extra_posts) }
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

  describe '#post_closing' do
    it 'returns close_general for post elected at general' do
      close_general = 1.day.ago
      close_all = 1.day.from_now
      election = build_stubbed(:election, :autumn,
                               close_general: close_general,
                               close_all: close_all)
      general_post = build_stubbed(:post, :autumn, :general)
      after_general_post = build_stubbed(:post, :autumn, :board)

      # We have to use "be_within(1.second).of" instead of "eq"
      # because the precision is too low
      election.post_closing(general_post).should be_within(1.second).of(close_general)
      election.post_closing(after_general_post).should be_within(1.second).of(close_all)
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

      # We have to use "be_within(1.second).of" instead of "eq"
      # because the precision is too low
      election.stub(:state).and_return(:not_opened)
      election.countdown.should be_within(1.second).of(open)

      election.stub(:state).and_return(:before_general)
      election.countdown.should be_within(1.second).of(close_general)

      election.stub(:state).and_return(:after_general)
      election.countdown.should be_within(1.second).of(close_all)

      election.stub(:state).and_return(:closed)
      election.countdown.should be_nil
    end
  end

  context 'post queries' do
    describe '#posts' do
      it 'returns according to semester' do
        election = create(:election)
        create(:post, :autumn, title: 'In the Autumn')
        create(:post, :spring, title: 'In the Spring')
        election.extra_posts << create(:post, semester: 'not_by_semester',
                                              title: 'An extra one')

        election.stub(:semester).and_return(Post::AUTUMN)
        election.posts.map(&:title).should eq(['In the Autumn'])

        election.stub(:semester).and_return(Post::SPRING)
        election.posts.map(&:title).should eq(['In the Spring'])

        election.stub(:semester).and_return(Post::OTHER)
        election.posts.map(&:title).should eq(['An extra one'])
      end
    end

    describe '#current_posts' do
      it 'returns according to state' do
        election = create(:election, :autumn)
        create(:post, :autumn, :general, title: 'Elected at General')
        create(:post, :autumn, :board, title: 'Elected by Board')

        election.stub(:state).and_return(:not_opened)
        election.current_posts.map(&:title).should eq(['Elected at General',
                                                       'Elected by Board'])

        election.stub(:state).and_return(:before_general)
        election.current_posts.map(&:title).should eq(['Elected at General',
                                                       'Elected by Board'])

        election.stub(:state).and_return(:after_general)
        election.current_posts.map(&:title).should eq(['Elected by Board'])

        election.stub(:state).and_return(:closed)
        election.current_posts.map(&:title).should eq([])
      end
    end

    describe '#current_posts' do
      it 'returns according to state' do
        election = build_stubbed(:election)
        election.stub(:current_posts).and_return('yeppyepp')

        election.stub(:state).and_return(:not_opened)
        election.searchable_posts.should eq(Post.none)

        election.stub(:state).and_return(:closed)
        election.searchable_posts.should eq(Post.none)

        election.stub(:state).and_return(:before_general)
        election.searchable_posts.should eq('yeppyepp')

        election.stub(:state).and_return(:after_general)
        election.searchable_posts.should eq('yeppyepp')
      end
    end
  end
end
