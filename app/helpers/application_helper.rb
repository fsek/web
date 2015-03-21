module ApplicationHelper
  def fa_icon(icon_name)
    content_tag :i, nil, class: ('fa fa-' + icon_name)
  end

  def title(page_title)
    content_for(:title) { page_title }
  end

  def full_title(page_title)
    base_title = 'F-sektionen'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
end
