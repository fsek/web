require 'rails_helper'

RSpec.describe ShortLink, type: :model do
  describe '#valid?' do
    subject { build :short_link }

    it 'accepts well-formed shortlink' do
      subject.should be_valid
    end

    it 'rejects without link' do
      subject.link = nil
      subject.should_not be_valid
    end

    it 'rejects without target' do
      subject.target = nil
      subject.should_not be_valid
    end

    it 'rejects duplicate link' do
      subject.save!
      other = subject.dup
      other.target = 'http://other.target.com/'
      other.should_not be_valid
    end

    it 'rejects invalid url' do
      subject.target = 'notarealurl'
      subject.should_not be_valid

      subject.target = 'https://invalid'
      subject.should_not be_valid
    end

    it 'rejects invalid link' do
      subject.link = 'imnot12313valid!'
      subject.should_not be_valid
    end

    it 'rejects link that collides with app routes' do
      subject.link = 'assets'
      subject.should_not be_valid
    end
  end

  describe '#target=' do
    it 'tacks on http when scheme is missing' do
      build(:short_link, target: 'google.com').
        target.should == 'http://google.com'
    end

    it 'does not mess with existing scheme' do
      build(:short_link, target: 'gopher://google.com').
        target.should == 'gopher://google.com'
    end
  end
end
