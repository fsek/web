require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  context 'default user' do
    let(:user) { create(:user) }
    let(:ability) { create(:user) }
    subject(:ability) { Ability.new(user) }

    # Stuff everyone can do
    it { should be_able_to :read, News.new }
    it { should be_able_to :read, Council.new}

    # Stuff everyone must not be able to do
    it { should_not be_able_to :read, Constant.new }
    it { should_not be_able_to :read, Album.new }
    it { should_not be_able_to :read, Candidate.new }
    # Not sure why it was shold_not here
    # 2015/03/26, d.wessman
    it { should be_able_to :read, Event.new }
    it { should_not be_able_to :read, Permission.new }
    # Not sure why it was shold_not here /d.wessman
    # 2015/03/26, d.wessman
    it { should be_able_to :read, Post.new }
    it { should_not be_able_to :read, Profile.new }
    it { should_not be_able_to :read, User.new }
  end

  context 'admin user' do
    let(:user) { create(:admin) }
    let(:ability) { create(:user) }
    subject(:ability) { Ability.new(user) }

    # Can do anything
    it { should be_able_to :manage, :all }
  end

end
