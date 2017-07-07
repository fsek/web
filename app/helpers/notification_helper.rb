module NotificationHelper
  def notification_context(notification, data)
    content_tag(:div, class: 'notification-content') do
      content = [fa_icon(data.icon)]
      content << asterisk_link(notification)
      content << content_tag(:span, markdown(data.title), class: 'title')
      content << content_tag(:span, markdown(data.body), class: 'body')
      content << content_tag(:span, markdown(data.extra), class: 'extra')
      safe_join(content)
    end
  end

  def asterisk_link(notification)
    content = []
    if notification.seen?
      content << fa_icon('asterisk 2x')
    else
      content << link_to(look_own_user_notification_path(notification), remote: true, method: :patch) do
        fa_icon('asterisk 2x')
      end
    end
    content_tag(:span, safe_join(content), class: 'asterisk pull-right')
  end

  def notification_created_at(time)
    content_tag(:span, class: 'notification-time pull-right') do
      content = []
      content << fa_icon('calendar')
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
