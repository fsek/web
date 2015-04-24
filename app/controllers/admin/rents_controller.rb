class Admin::RentsController < ApplicationController
  load_permissions_and_authorize_resource
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
    redirect_to @rent
  end

  def new
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

  # To set the councils
  def set_councils
    @councils = Council.all
  end

  def rent_params
    params.require(:rent).permit(:d_from, :d_til, :name, :lastname, :email,
                                 :phone, :purpose, :disclaimer, :council_id,
                                 :comment, :access_code, :status, :aktiv,
                                 :service)
  end
end
