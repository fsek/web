# encoding:UTF-8
class RentsController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :set_rents, except: [:main, :index]

  def main
    @faqs = Faq.answered.category('Bil')
    respond_to do |format|
      format.html
      format.json { render json: Rent.between(params[:start], params[:end]).active }
    end
  end

  def new
    @TOA = Document.find_by(title: 'Regler för Beerit')
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
    redirect_to :bil, notice: alert_destroy(@rent)
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

  # @rents: used to show rents under the form when creating new.
  def set_rents
    id = params[:id] || nil
    @rents = Rent.active.date_overlap(Time.zone.now, Time.zone.now+30.days, id).limit(10).ascending
  end

  def rent_params
    params.require(:rent).permit(:d_from, :d_til, :purpose, :disclaimer, :council_id)
  end
end
