require 'rails_helper'
require 'cancan_matchers'

describe Ability do
  context 'not_signed_in' do
    subject(:ability) { Ability.new(nil) }

    context 'album' do
      it { should not_have_abilities([:read, :new, :edit], Album.new) }
    end

    context 'cafe_work' do
      it { should have_abilities(:read, CafeWork.new) }
      it { should not_have_abilities([:new, :edit,
                                      :add_worker, :update_worker,
                                      :remove_worker, :nyckelpiga], CafeWork.new) }
    end

    context 'candidate' do
      it { should not_have_abilities([:read, :new, :edit], Candidate.new) }
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
end
