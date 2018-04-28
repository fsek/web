class FredmanskyData
  TITLE = 'Fredmans'.freeze
  BODY = 'Fredmans! Fredmans! Fredmans! 🍺 🍻'.freeze

  def self.android_data
    { title: TITLE, body: BODY, notId: 0 }
  end

  def self.ios_notification
    { title: TITLE, body: BODY }
  end

  def self.ios_data
    { notification_id: 0 }
  end
end
