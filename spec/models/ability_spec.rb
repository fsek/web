require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  subject(:ability) { Ability.new(user) }

  context 'not_signed_in' do
    subject(:ability) { Ability.new(nil) }

    # Stuff everyone can do
    it { should be_able_to :read, News.new }
    it { should be_able_to :read, Council.new }
    it { should be_able_to :read, CafeWork.new }

    # Stuff everyone must not be able to do
    it { should_not be_able_to :read, Constant.new }
    it { should_not be_able_to :read, Album.new }
    it { should_not be_able_to :read, Post.new }
    it { should_not be_able_to :read, Event.new }
    it { should_not be_able_to :read, Candidate.new }
    it { should_not be_able_to :read, Permission.new }
    it { should_not be_able_to :read, User.new }
  end

  context 'default user' do
    let(:user) { create(:user) }
    let(:ability) { create(:user) }
    subject(:ability) { Ability.new(user) }

    # Stuff everyone can do
    it { should be_able_to :read, Event.new }
    it { should be_able_to :read, Council.new }
    it { should be_able_to :read, CafeWork.new }
    it { should be_able_to :read, News.new }
    it { should be_able_to :read, Post.new }
    it { should be_able_to :read, Election.new }


    # Stuff everyone must not be able to do
    it { should_not be_able_to :read, Constant.new }
    it { should_not be_able_to :read, Album.new }
    it { should_not be_able_to :read, Candidate.new }
    it { should_not be_able_to :read, Permission.new }
    it { should_not be_able_to :read, Profile.new }
    it { should_not be_able_to :read, User.new }
  end

  context 'admin user' do
    let(:user) { create(:admin) }

    # Can do anything
    it { should be_able_to :manage, :all }
  end

end
