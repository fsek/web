class PushService
  def self.push(notification)
    app = Rpush::Gcm::App.find_by!(name: "firebase")
    content = push_content(notification.notifyable, notification.mode)

    android_clients = notification.user.push_devices.android.pluck(:token)
    ios_clients = notification.user.push_devices.ios.pluck(:token)

    if android_clients.present?
      Rpush::Gcm::Notification.create!(app: app, registration_ids: android_clients, data: content)
    end
    if ios_clients.present?
      Rpush::Gcm::Notification.create!(app: app, registration_ids: ios_clients, notification: content)
    end
  end

  def self.push_content(notifyable, mode)
    if notifyable.instance_of?(EventUser)
      if mode == "position"
        position_content(notifyable)
      elsif mode == "reminder"
        reminder_content(notifyable)
      end
    end
  end

  def self.position_content(event_user)
    title = event_user.event.title

    if event_user.reserve?
      body = I18n.t('service.push.reserve_position')
    else
      body = I18n.t('service.push.attending')
    end

    content = { title: title, body: body }
  end

  def self.reminder_content(event_user)
    title = event_user.event.title
    body = I18n.t('service.push.starts_soon', time: I18n.l(event_user.event.starts_at))

    content = { title: title, body: body}
  end
end
