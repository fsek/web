# Helps creating menu links
module MenuHelper
  def menu_dropdown_render(menus, cls: '')
    content_tag(:ul, class: cls) do
      content = []
      menus.each do |m|
        content << render(m.to_partial_path, menu: m)
      end
      safe_join(content)
    end
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

  def menu_link(menu, locale)
    link_to(menu_content(menu), menu_locale_link(menu.link, locale),
            menu_options(menu.blank_p, menu.turbolinks))
  end

  def menu_content(menu)
    content = [menu.to_s]
    content << fa_icon('external-link') if menu.blank_p
    safe_join(content)
  end

  def menu_options(blank, turbolinks)
    options = {}
    options[:target] = :blank if blank
    options['data-turbolinks'] = turbolinks.to_s
    options
  end

  def menu_class(blank)
    return "menu blank" if blank
    "menu"
  end
end
