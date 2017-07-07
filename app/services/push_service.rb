class PushService
  def self.push(notification)
    app = Rpush::Gcm::App.find_by!(name: "firebase")
    data = notification.data

    push_android(notification, data, app)
    push_ios(notification, data, app)
  end

  def self.push_android(notification, data, app)
    clients = notification.user.push_devices.android.pluck(:token)
    return if clients.blank?

    Rpush::Gcm::Notification.create!(app: app,
                                     priority: :high,
                                     data: data.for_android,
                                     registration_ids: clients)
  end

  def self.push_ios(notification, data, app)
    clients = notification.user.push_devices.ios.pluck(:token)
    return if clients.blank?

    ios_data = { notification_id: notification.id }
    Rpush::Gcm::Notification.create!(app: app,
                                     data: ios_data,
                                     priority: :high,
                                     notification: data.for_ios,
                                     registration_ids: clients)
  end
end
