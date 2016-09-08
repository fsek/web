class NotificationsController < ApplicationController
  load_permissions_and_authorize_resource through: :current_user

  def index
    @notifications = current_user.notifications.includes(:notifyable).by_latest.page(params[:page])
  end

  def look
    @notification.update(seen: true)
    current_user.reload
    render
  end

  def look_all
    current_user.notifications.not_seen.update_all(seen: true)
    current_user.update!(notifications_count: 0)
    redirect_to(own_user_notifications_path,
                notice: I18n.t('model.notification.all_marked_as_seen'))
  end
end
