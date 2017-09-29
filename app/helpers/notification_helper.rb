module NotificationHelper
  def notification_context(notification, data)
    content_tag(:div, markdown(data.body), class: 'body')
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
    content_tag(:span, class: 'notification-time') do
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
