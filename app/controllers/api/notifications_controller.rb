class Api::NotificationsController < Api::BaseController
  load_permissions_and_authorize_resource through: :current_user

  def index
    @notifications = current_user.notifications.for_index.page(params[:page])
    render json: @notifications, meta: notification_meta
  end

  def unread
    render json: { unread: current_user.notifications_count }
  end

  def look
    @notification = current_user.notifications.find(params[:id])

    if @notification && @notification.update(seen: true)
      current_user.reload
      render json: { unread: current_user.notifications_count }, status: :ok
    else
      render json: { errors: 'Failed to mark notification as read' }, status: 422
    end
  end

  private

  def notification_meta
    pagination_meta(@notifications).merge(unread: current_user.notifications_count)
  end
end
