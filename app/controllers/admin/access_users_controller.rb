class Admin::AccessUsersController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @access_users = initialize_grid(AccessUser.all)
  end

  def new
    @access_user = AccessUser.new
  end

  def create
    @access_user = AccessUser.new(access_user_params)
    if @access_user.save
      redirect_to admin_access_users_path, notice: alert_create(AccessUser)
    else
      redirect_to setup_admin_doors_path, notice: alert_danger(@access_user.errors.full_messages)
    end
  end

  def update
    if @access_user.update(access_user_params)
      redirect_to(admin_access_users_path, notice: alert_update(AccessUser))
    else
      redirect_to(edit_admin_access_user_path(@access_user),
        notice: alert_danger(@access_user.errors.full_messages))
    end
  end

  def destroy
    @access_user.destroy!
    redirect_to(admin_access_users_path, notice: alert_destroy(AccessUser))
  end

  private

  def access_user_params
    params.require(:access_user).permit(:user_id, :door_id, :purpose)
  end
end
