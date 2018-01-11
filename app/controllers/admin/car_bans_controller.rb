class Admin::CarBansController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @grid = initialize_grid(CarBan, order: :created_at)
  end

  def new
    @car_ban = CarBan.new
  end

  def edit
    @car_ban = CarBan.find(params[:id])
  end

  def create
    @car_ban = CarBan.new(car_ban_params)
    @car_ban.creator = current_user

    if @car_ban.save
      redirect_to admin_car_bans_path, notice: alert_create(CarBan)
    else
      render :new, status: 422
    end
  end

  def update
    @car_ban = CarBan.find(params[:id])

    if @car_ban.update(car_ban_params)
      redirect_to admin_car_bans_path, notice: alert_update(CarBan)
    else
      render :edit, status: 422
    end
  end

  def destroy
    car_ban = CarBan.find(params[:id])
    car_ban.destroy!

    redirect_to admin_car_bans_path, notice: alert_destroy(CarBan)
  end

  private

  def car_ban_params
    params.require(:car_ban).permit(:user_id, :reason)
  end
end
