# encoding:UTF-8
class RentsController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :load_terms, only: [:new, :edit, :create, :update]

  def main
    @faqs = Faq.answered.category('Bil')
    respond_to do |format|
      format.html
      format.json do
        render json: Rent.between(params[:start], params[:end]).active
      end
    end
  end

  def new
  end

  def show
  end

  def edit
  end

  def create
    if RentService.reservation(current_user, @rent)
      redirect_to rent_path(@rent), notice: alert_create(Rent)
    else
      render action: :new
    end
  end

  def update
    if RentServices.update(rent_params, current_user, @rent)
      redirect_to edit_rent_path(@rent), notice: alert_update(Rent)
    else
      render action: :edit
    end
  end

  def destroy
    @rent.destroy
    redirect_to :rents, notice: alert_destroy(Rent)
  end

  # Index page available to logged in users.
  def index
    @rents = current_user.rents.order('d_from desc')
  end

  private

  def rent_params
    params.require(:rent).permit(:d_from, :d_til, :purpose,
                                 :disclaimer, :council_id)
  end

  def load_terms
    constant = Constant.find_by(name: 'rents_disclaimer_id')
    @terms = Document.find_by(id: constant.try(:value))
  end
end
