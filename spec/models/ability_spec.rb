require 'rails_helper'
require 'cancan_matchers'

describe Ability do
  context 'member' do
    let(:user) { create(:user, member_at: Time.zone.now) }
    subject(:ability) { Ability.new(user) }

    context 'album' do
      it { should not_have_abilities([:read, :new, :edit], Album.new) }
    end

    context 'cafe_work' do
      it { should have_abilities([:read, :add_worker], build(:cafe_work)) }
      it { should have_abilities([:read, :update_worker,
                                  :edit, :remove_worker], build(:cafe_work, user: user)) }
      it { should not_have_abilities([:new, :nyckelpiga], CafeWork.new) }
    end

    context 'candidate' do
      it { should have_abilities([:read, :new, :edit], Candidate.new) }
      it { should have_abilities([:read, :new, :edit], Candidate.new) }
    end

    context 'constant' do
      it { should not_have_abilities([:read, :new, :edit], Constant.new) }
    end

    context 'contact' do
      it { should have_abilities([:read, :mail], Contact.new(public: true)) }
      it { should not_have_abilities([:new, :edit], Contact.new) }
      it { should not_have_abilities([:show, :mail], Contact.new(public: false)) }
    end

    context 'council' do
      it { should have_abilities(:read, Council.new) }
      it { should not_have_abilities([:new, :edit], Council.new) }
    end

    context 'document' do
      it { should have_abilities(:read, Document.new(public: true)) }
      it { should not_have_abilities([:new, :edit], Document.new) }
      it { should not_have_abilities(:show, Document.new(public: false)) }
    end

    context 'election' do
      it { should have_abilities(:index, Election.new) }
      it { should not_have_abilities([:new, :edit], Election.new) }
    end

    context 'event' do
      it { should not_have_abilities([:read, :new, :edit], Event.new) }
    end

    context 'faq' do
      it { should have_abilities(:read, Faq.new) }
      it { should not_have_abilities([:update, :edit], Faq.new) }
    end

    context 'menu' do
      it { should not_have_abilities([:read, :new, :edit], Menu.new) }
    end

    context 'news' do
      it { should have_abilities(:read, News.new) }
      it { should not_have_abilities([:new, :edit], News.new) }
    end

    context 'nomination' do
      it { should not_have_abilities([:new, :create], Nomination.new) }
    end

    context 'notice' do
      it { should have_abilities([:display, :image], Notice.new) }
      it { should not_have_abilities([:read, :new, :edit], Notice.new) }
    end

    context 'page_element' do
      it { should not_have_abilities([:read, :new, :edit], PageElement.new) }
    end

    context 'page' do
      it { should not_have_abilities([:new, :edit], Page.new) }
    end

    context 'permission' do
      it { should not_have_abilities([:read, :new, :edit], Permission.new) }
    end

    context 'post' do
      it { should have_abilities([:collapse, :display], Post.new) }
      it { should not_have_abilities([:index, :new, :edit], Post.new) }
    end

    context 'rent' do
      it { should have_abilities(:main, Rent.new) }
      it { should not_have_abilities([:new, :edit], Rent.new) }
    end
  end

  context 'default user' do
    let(:user) { create(:user) }
    let(:ability) { create(:user) }
    subject(:ability) { Ability.new(user) }

    # Stuff everyone can do
    it { should have_abilities :read, Event.new }
    it { should have_abilities :read, Council.new }
    #it { should have_abilities :read, CafeWork.new }
    it { should have_abilities :read, News.new }
    it { should have_abilities :read, Post.new }
    it { should have_abilities :read, Election.new }


    # Stuff everyone must not be able to do
    it { should_not have_abilities :read, Constant.new }
    it { should_not have_abilities :read, Candidate.new }
    it { should_not have_abilities :read, Permission.new }
    it { should_not have_abilities :read, User.new }
  end


  context 'admin user' do
    let(:user) { create(:admin) }
    subject(:ability) { Ability.new(user) }

    # Can do anything
    it { should have_abilities(:manage, :all) }
  end

end
