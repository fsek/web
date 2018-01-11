class RentsController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :load_terms, only: [:new, :edit, :create, :update, :main, :index]

  def index
    respond_to do |format|
      format.html do
        @faqs = Faq.answered.category('Bil')
      end

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
    if RentService.reservation(current_user, @rent, @terms)
      redirect_to rent_path(@rent), notice: alert_create(Rent)
    else
      render :new, status: 422
    end
  end

  def update
    if RentService.update(rent_params, current_user, @rent)
      redirect_to edit_rent_path(@rent), notice: alert_update(Rent)
    else
      render :edit, status: 422
    end
  end

  def destroy
    @rent.destroy!

    redirect_to rents_path, notice: alert_destroy(Rent)
  end

  def overview
    @rents = current_user.rents.order(d_from: :desc)
  end

  private

  def rent_params
    params.require(:rent).permit(:d_from, :d_til, :purpose,
                                 :council_id, :user_id, :terms)
  end

  def load_terms
    @terms = Document.find_by(slug: 'rental-terms')
  end
end
