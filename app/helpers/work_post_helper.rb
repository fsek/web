module WorkPostHelper
  def work_post_link(work_post)
    if work_post.present? && work_post.link.present?
      link_to(work_post.link, work_post.link,
              class: 'btn primary small link')
    end
  end

  def work_post_info_title(title, value)
    content = safe_join([work_post_title(title), work_post_value(value)])
    content_tag(:span, content, class: 'info')
  end

  def work_post_title(title)
    if title.present?
      content_tag(:span, title, class: 'title')
    end
  end

  def work_post_value(value)
    if value.present?
      content_tag(:span, value, class: 'value')
    end
  end
end
