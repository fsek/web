class Admin::UsersController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @user_grid = initialize_grid(@users, order: :id)
  end

  def bloodfeud
    @donated_grid = initialize_grid(User.where(donated: true))
    @user_grid = initialize_grid(User.all)
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
    user.update(donated: true)
    user.update(donation_confirmed: true)
    redirect_to admin_anvandare_bloodfeud_path, notice: "Donation has been confirmed for: " + user.firstname + " " + user.lastname
  end

  def unconfirm_donation
    user = User.find(params[:id])
    user.update(donation_confirmed: false)
    redirect_to admin_anvandare_bloodfeud_path, notice: alert_danger("Donation has been unconfirmed for: " + user.firstname + " " + user.lastname)
  end

  def export
    respond_to do |format|
      format.csv do
        send_data(ExportCSV.volonteers(@users), filename: "volonteer_register_#{Time.now}.csv")
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:firstname, :lastname, :student_id)
  end
end
