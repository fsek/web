class NotificationsController < ApplicationController
  load_permissions_and_authorize_resource through: :current_user

  def index
    @notifications = current_user.notifications.for_index.page(params[:page])
  end

  def look_all
    if current_user.notifications.not_seen.update_all(seen: true)
      current_user.update!(notifications_count: 0)
      render json: { unread: current_user.notifications_count }, status: :ok
    else
      render json: { errors: 'Failed to mark all notifications as read' }, status: 422
    end
  end

  def visit
    @notification = current_user.notifications.find(params[:id])

    if @notification&.update(visited: true)
      current_user.reload
      render json: {}, status: :ok
    else
      render json: { errors: 'Failed to visit notification' }, status: 422
    end
  end
end
