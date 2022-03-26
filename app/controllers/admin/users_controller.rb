class Admin::UsersController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @user_grid = initialize_grid(@users, order: :id)
  end

  def bloodfeud
   @donated_grid = initialize_grid(User.where(donated: true))
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to admin_users_path, notice: alert_update(User)
    else
      render :edit, status: 422
    end
  end

  def member
    @success = UserService.make_member(@user)
    render
  end

  def unmember
    @destroyed = UserService.unmember(@user)
  end

  def confirm_donation
    user = User.find(params[:id])
    user.update(donation_confirmed: true)
    redirect_to admin_anvandare_bloodfeud_path, notice: "Donation has been confirmed for: " + user.firstname + " " + user.lastname
  end

  def unconfirm_donation
    user = User.find(params[:id])
    user.update(donation_confirmed: false)
    redirect_to admin_anvandare_bloodfeud_path, notice: alert_danger("Donation has been unconfirmed for: " + user.firstname + " " + user.lastname)
  end

  private

  def user_params
    params.require(:user).permit(:firstname, :lastname, :student_id)
  end
end
