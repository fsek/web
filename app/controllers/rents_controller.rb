# encoding:UTF-8
class RentsController < ApplicationController
  load_permissions_and_authorize_resource

  def main
    @faqs = Faq.answered.category('Bil')
    respond_to do |format|
      format.html
      format.json { render json: Rent.between(params[:start], params[:end]).active }
    end
  end

  def new
    @terms = Document.find_by(title: 'Regler för Beerit')
  end

  def show
  end

  def edit
  end

  def create
    @rent = Rent.new_with_status(rent_params, current_user)
    if @rent.save
      redirect_to @rent, notice: alert_create(Rent)
    else
      render action: :new
    end
  end

  def update
    if @rent.update_with_authorization(rent_params, current_user)
      flash[:notice] = alert_update(Rent)
      redirect_to edit_rent_path(@rent)
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
    if current_user.present?
      @rents = current_user.rents.order('d_from desc')
      render action: 'index'
    else
      redirect_to(action: 'main')
    end
  end

  private

  def rent_params
    params.require(:rent).permit(:d_from, :d_til, :purpose, :disclaimer, :council_id)
  end
end
