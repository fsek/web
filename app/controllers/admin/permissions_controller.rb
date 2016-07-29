# encoding: UTF-8
class Admin::PermissionsController < Admin::BaseController
  load_permissions_and_authorize_resource
  load_and_authorize_resource :position

  def index
    @positions = Position.includes(:permissions).by_title
  end

  def show_position
    @permissions = Permission.by_subject
  end

  def update_position
    if @position.set_permissions(permission_params)
      redirect_to admin_permissions_path, notice: alert_update(Position)
    else
      render :show_position, status: 422
    end
  end

  private

  def permission_params
    params.require(:position).permit(permission_ids: [])
  end
end
