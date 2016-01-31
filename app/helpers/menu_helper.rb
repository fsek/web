module MenuHelper
  def menu_dropdown(menus:, title:)
    content = safe_join([menu_dropdown_link(title), menu_dropdown_render(menus)])
    content_tag(:li, content, class: 'dropdown')
  end

  def menu_dropdown_link(title)
    link_to(menu_dropdown_title(title), '#', class: 'dropdown-toggle',
                                             data: { toggle: 'dropdown',
                                                     hover: 'dropdown',
                                                     delay: '0',
                                                     close_others: 'false' })
  end

  def menu_dropdown_title(title)
    safe_join([title, ' ', fa_icon('angle-down')])
  end

  def menu_dropdown_render(menus)
    content_tag(:ul, render(partial: 'menus/menu', collection: menus), class: 'dropdown-menu')
  end
end
