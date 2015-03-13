class Admin::RentsController < ApplicationController
  before_action :login_required
  before_action :authenticate
  before_action :set_rent, only: [:show, :update, :destroy, :preview]
  before_action :set_councils, only: [:new, :show]

  def main
    @rents = Rent.ascending.from_date(Time.zone.now.beginning_of_day)
    @rent_grid = initialize_grid(@rents)
    @faqs = Faq.where(answer: '').where(category: 'Bil')
  end

  def show
  end

  def preview
  end

  def create
    @rent = Rent.new_with_status(rent_params, nil)
    flash[:notice] = 'Bokningen skapades' if @rent.save(validate: false)
    respond_with @rent
  end

  def new
    @rent = Rent.new
  end

  def update
    @rent.update_without_validation(rent_params)
    redirect_to admin_rent_path(@rent), notice: 'Bokningen uppdaterades.'
  end

  def destroy
    @rent.destroy
    redirect_to :admin_car, notice: 'Bokningen raderades.'
  end

  private

  def authenticate
    flash[:error] = t('the_role.access_denied')
    redirect_to(:back) unless (current_user) && (current_user.moderator?(:bil))
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  # Makes sure that a rent is found, otherwise redirects to admin page
  def set_rent
    @rent = Rent.find_by_id(params[:id])
    if (@rent == nil)
      flash[:notice] = 'Hittade ingen bilbokning med det ID:t.'
      redirect_to(:admin_car)
    end
  end

  # To set the councils
  def set_councils
    @councils = Council.all
  end

  def rent_params
    params.require(:rent).permit(:d_from, :d_til, :name, :lastname, :email, :phone, :purpose, :disclaimer,
                                 :council_id, :comment, :access_code, :status, :aktiv, :comment, :service)
  end
end