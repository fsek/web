require 'rails_helper'

describe MailAlias do
  describe '#validate!' do
    it 'requires all fields' do
      [ :username, :domain, :target ].each do |a|
        build_stubbed(:mail_alias, a => nil).should_not be_valid
      end
    end

    it 'validates the provided example' do
      build_stubbed(:mail_alias).should be_valid
    end

    it 'rejects duplicate aliases on the same domain' do
      create :mail_alias, :username => 'johan', :domain => 'fsektionen.se',
        :target => 'jaforberg@gmail.com'
      build(:mail_alias, :username => 'johan', :domain => 'fsektionen.se',
            :target => 'jaforberg@gmail.com').should_not be_valid
    end

    it 'rejects invalid domains' do
      build(:mail_alias, :domain => 'microsoft.com').should_not be_valid
    end

    it 'rejects bad username formats' do
      build(:mail_alias, :username => 'yeaha@#$@$^').should_not be_valid
    end

    it 'rejects bad target formats' do
      build(:mail_alias, :target => 'bitches').should_not be_valid
    end
  end

  describe '#address' do
    it 'returns the expected value' do
      build(:mail_alias, :username => 'johan',
            :domain => 'fsektionen.se').address.should == 'johan@fsektionen.se'
    end
  end

  describe '.fulltext_search' do
    it 'works as expected for a few examples' do
      m1 = create(:mail_alias, :username => 'johan', :domain => 'fsektionen.se',
                  :target => 'jaforberg@gmail.com')
      m2 = create(:mail_alias, :username => 'erik', :domain => 'fsektionen.se',
                  :target => 'erikhenrikssn@gmail.com')

      MailAlias.fulltext_search('johan').should == [ m1 ]
      MailAlias.fulltext_search('jo').should == [ m1 ]
      MailAlias.fulltext_search('johannes').should == [ ]
      MailAlias.fulltext_search('erik').should == [ m2 ]
      MailAlias.fulltext_search('johan@fsektionen.se').should == [ m1 ]
      MailAlias.fulltext_search('jaforberg@gmail.com').should == [ m1 ]
    end
  end

  describe '.insert_aliases!' do
    it 'can set empty target list (clear)' do
      c = create :mail_alias
      MailAlias.insert_aliases! c.username, c.domain, []
      MailAlias.count.should == 0
    end

    it 'can create new alias' do
      c = build :mail_alias
      ts = [ 'test@gmail.com', 'hej@what.com', 'lol@whut.se' ]
      MailAlias.insert_aliases! c.username, c.domain, ts
      MailAlias.all.pluck(:target).should =~ ts
    end

    it 'touches existing records' do
      c = create :mail_alias, :updated_at => 1.month.ago
      MailAlias.insert_aliases! c.username, c.domain, [ c.target ]
      MailAlias.count.should == 1
      MailAlias.first.updated_at.to_date.should == Time.zone.now.to_date
    end
  end
end
