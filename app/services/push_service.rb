class PushService
  def self.push(data_object, users)
    app = Rpush::Gcm::App.find_by!(name: "firebase")
    push_android(data_object, app, users)
    push_ios(data_object, app, users)
  end

  def self.push_android(data_object, app, users)
    clients = get_clients(users, :android)
    return if clients.blank?

    # Firebase supports 1000 registration ids/notification
    clients.each_slice(1000) do |c|
      Rpush::Gcm::Notification.create!(app: app,
                                       priority: :high,
                                       data: data_object.android_data,
                                       registration_ids: c)
    end
  end

  def self.push_ios(data_object, app, users)
    clients = get_clients(users, :ios)
    return if clients.blank?

    # Firebase supports 1000 registration ids/notification
    clients.each_slice(1000) do |c|
      Rpush::Gcm::Notification.create!(app: app,
                                       data: data_object.ios_data,
                                       priority: :high,
                                       notification: data_object.ios_notification,
                                       registration_ids: c)
    end
  end

  def self.get_clients(users, system)
    if users.is_a?(ActiveRecord::Relation) # Multiple users
      users.joins(:push_devices).merge(PushDevice.where(system: system)).pluck(:token)
    else # One user
      users.push_devices.where(system: system).pluck(:token)
    end
  end
end
