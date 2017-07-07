class NotificationData
  attr_reader :title, :body, :extra, :icon, :link, :notification

  def initialize(notification)
    @notification = notification
    @notifyable = notification.notifyable

    if @notification.notifyable_type == 'EventUser'
      init_event_user
    end
  end

  def for_serializer
    { title: title, body: body, extra: extra }
  end

  def for_android
    { title: title, body: body, notId: notification.id}
  end

  def for_ios
    { title: title, body: body }
  end

  private

  def init_event_user
    @title = @notifyable.event.title
    @link = @notifyable.event

    if @notification.mode == 'position'
      init_position
    elsif @notification.mode == 'reminder'
      init_reminder
    end
  end

  def init_position
    @icon = 'hashtag'
    if @notifyable.reserve?
      @body = I18n.t('model.notification_data.reserve_position', event: @notifyable.event)
    else
      @body = I18n.t('model.notification_data.attending', event: @notifyable.event)
    end

    if @notifyable.event_signup.notification_message.present?
      @extra = @notifyable.event_signup.notification_message
    end
  end

  def init_reminder
    @icon = 'calendar'
    @body = I18n.t('model.notification_data.remind_soon_starting',
                   event: @notifyable.event,
                   time: I18n.l(@notifyable.event.starts_at))
  end
end
