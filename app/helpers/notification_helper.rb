module NotificationHelper
  def notification_context(notification, data)
    content_tag(:div, markdown(data.body), class: "body")
  end

  def notification_icon(notification)
    if notification.notifyable_type == "EventUser"
      if notification.mode == "position"
        icon("fas", "check")
      else
        icon("fas", "glass-cheers")
      end
    elsif notification.mode == "closing"
      icon("fas", "user-clock")
    else
      icon("fas", "user-plus")
    end
  end

  def notification_created_at(time)
    content_tag(:span, class: "notification-time") do
      content = []
      content << icon("far", "calendar-alt")
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
