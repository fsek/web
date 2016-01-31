require 'rails_helper'

RSpec.describe GlobalMenus do
  describe '#guild_menus' do
    it 'lists guild menus' do
      create(:menu, name: 'Second', location: Menu::GUILD, index: 20)
      create(:menu, name: 'First', location: Menu::GUILD, index: 10)
      create(:menu, name: 'Not listed', location: Menu::MEMBER, index: 20)

      menus = GlobalMenus.new

      menus.guild_menus.map(&:name).should eq(['First',
                                               'Second'])
    end

    it 'returns empty array if no menus' do
      menus = GlobalMenus.new
      menus.guild_menus.should eq([])
    end
  end

  describe '#member_menus' do
    it 'lists member menus' do
      create(:menu, name: 'Second', location: Menu::MEMBER, index: 20)
      create(:menu, name: 'First', location: Menu::MEMBER, index: 10)
      create(:menu, name: 'Not listed', location: Menu::GUILD, index: 20)

      menus = GlobalMenus.new

      menus.member_menus.map(&:name).should eq(['First',
                                                'Second'])
    end
  end

  describe '#company_menus' do
    it 'lists company menus' do
      create(:menu, name: 'Second', location: Menu::COMPANY, index: -20)
      create(:menu, name: 'First', location: Menu::COMPANY, index: -100)
      create(:menu, name: 'Not listed', location: Menu::GUILD, index: 20)

      menus = GlobalMenus.new

      menus.company_menus.map(&:name).should eq(['First',
                                                 'Second'])
    end
  end

  describe '#contact_menus' do
    it 'lists contact menus' do
      create(:menu, name: 'Second', location: Menu::CONTACT, index: -20)
      create(:menu, name: 'First', location: Menu::CONTACT, index: -100)
      create(:menu, name: 'Not listed', location: Menu::GUILD, index: 20)

      menus = GlobalMenus.new

      menus.contact_menus.map(&:name).should eq(['First',
                                                 'Second'])
    end
  end
end
