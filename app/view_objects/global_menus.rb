class GlobalMenus
  attr_accessor :guild_menus, :member_menus, :company_menus, :contact_menus

  def initialize
    menus = Menu.index.group_by(&:location)
    @guild_menus = menus[Menu::GUILD] || []
    @member_menus = menus[Menu::MEMBER] || []
    @company_menus = menus[Menu::COMPANY] || []
    @contact_menus = menus[Menu::CONTACT] || []
  end
end
