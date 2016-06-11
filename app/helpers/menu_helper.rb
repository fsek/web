module MenuHelper

  def menu_dropdown_render(menus, cls: '')
    content_tag(:ul, render(partial: 'menus/menu', collection: menus), class: cls)
  end

  def menu_locale_link(link, locale)
    if link.present? && locale.present?
      if !link.start_with?('http', 'https') && locale.to_s == 'en'
        "/en#{link}"
      else
        link
      end
    end
  end
end
