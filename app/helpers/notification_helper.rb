module NotificationHelper
  def notification_context(notification, data)
    content_tag(:div, markdown(data.body), class: 'body')
  end

  def notification_icon(notification)
    icon = ''
    if notification.notifyable_type == 'EventUser'
      if notification.mode == 'position'
        icon = icon('fas', 'check')
      elsif notification.mode == 'album'
        icon = icon('fas', 'images')
      else
        icon = icon('fas', 'glass-cheers')
      end
    else
      if notification.mode == 'closing'
        icon = icon('fas', 'user-clock')
      else
        icon = icon('fas', 'user-plus')
      end
    end
    icon
  end

  def notification_created_at(time)
    content_tag(:span, class: 'notification-time') do
      content = []
      content << icon('far', 'calendar-alt')
      content << localize(time)
      safe_join(content)
    end
  end

  def notification_page_title(title, count)
    if count.positive?
      "#{title} (#{count})"
    else
      title
    end
  end
end
