class Admin::GroupUsersController < Admin::BaseController
  load_permissions_and_authorize_resource
  load_resource :group

  def index
    @grid = initialize_grid(GroupUser.where(group_id: @group.id), include: :user)
  end

  def set_fadder
    @group_user = GroupUser.find(params[:id])
    @success = @group_user.update(fadder: true)
    render
  end

  def set_not_fadder
    @group_user = GroupUser.find(params[:id])
    @success = @group_user.update(fadder: false)
    render
  end
end
