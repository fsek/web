module NotificationHelper
  def notification_context(text, notification, icon: 'bell')
    content_tag(:span, class: 'notification-content') do
      content = []
      content << fa_xl_icon(icon)
      content << asterisk_link(notification)
      content << content_tag(:span, markdown(text), class: 'text')
      safe_join(content)
    end
  end

  def asterisk_link(notification)
    content = []
    if notification.seen?
      content << fa_lg_icon('asterisk')
    else
      content << link_to(look_own_user_notification_path(notification), remote: true, method: :patch) do
        fa_lg_icon('asterisk')
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
    if count > 0
      "#{title} (#{count})"
    else
      title
    end
  end

  def event_user_notification(event_user)
    text = ''
    if event_user.reserve?
      text << t('.reserve_position', event: event_user.event.to_s,
                                     position: event_user.reserve_position)
    else
      text << t('.attending', event: event_user.event.to_s)
    end

    if event_user.event_signup.notification_message.present?
      text << '<br>' << event_user.event_signup.notification_message
    end
    text
  end
end
