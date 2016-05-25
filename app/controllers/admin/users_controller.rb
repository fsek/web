class Admin::UsersController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @user_grid = initialize_grid(@users)
  end

  def member
    @success = UserService.make_member(@user)
    render
  end

  def unmember
    @destroyed = UserService.unmember(@user)
    render
  end
end
