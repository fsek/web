class Admin::RentsController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :prepare, only: [:new, :show]

  def index
    @rents = Rent.ascending.from_date(Time.zone.now.beginning_of_day)
    @rent_grid = initialize_grid(@rents)
    @faqs = Faq.where(answer: '').where(category: 'Bil')
  end

  def show
  end

  def preview
  end

  def create
    if RentService.admin_reservation(@rent)
      redirect_to admin_rent_path(@rent), notice: alert_create(Rent)
    else
      render :new
    end
  end

  def new
    @rent.user = nil
  end

  def update
    if RentService.administrate(@rent, rent_params)
      redirect_to admin_rent_path(@rent), notice: alert_update(Rent)
    else
      render :show
    end
  end

  def destroy
    @rent.destroy
    redirect_to :admin_rents, notice: alert_destroy(Rent)
  end

  private

  def prepare
    @councils = Council.all_name
    @users = User.all_firstname
  end

  def rent_params
    params.require(:rent).permit(:d_from, :d_til, :user_id,
                                 :purpose, :disclaimer, :council_id,
                                 :comment, :status, :aktiv, :service)
  end
end
