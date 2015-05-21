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
    flash[:notice] = alert_create(Rent) if @rent.save(validate: false)
    redirect_to admin_rent_path(@rent)
  end

  def new
    @rent.user = nil
  end

  def update
    @rent.update_without_validation(rent_params)
    redirect_to admin_rent_path(@rent), notice: alert_update(Rent)
  end

  def destroy
    @rent.destroy
    redirect_to :admin_car, notice: alert_destroy(Rent)
  end

  private

  # To set the councils
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
