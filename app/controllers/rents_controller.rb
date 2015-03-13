# encoding:UTF-8
class RentsController < ApplicationController
  before_action :set_rents, only: [:new, :edit, :create, :update, :authorize]
  before_action :set_rent, only: [:show, :edit, :update, :authorize]
  respond_to :html, :json

  def main
    @faqs = Faq.answered.category('Bil')
    respond_to do |format|
      format.html
      format.json { render json: Rent.between(params[:start], params[:end]).active }
    end
  end

  def new
    @TOA = Document.where(title: "Regler för Beerit").first
    @rent = Rent.new
    if (current_user)
      @rent.prepare(current_user.profile)
      @utskott = current_user.profile.car_councils
    end
  end

  def show
  end

  def edit
    if @rent.profile
      @profile = @rent.profile
      @utskott = @rent.profile.car_councils
    end
  end

  def create
    @rent = Rent.new_with_status(rent_params, current_user)
    flash[:notice] = 'Bokningen skapades, skickat mailbekräftelse.' if @rent.save
    respond_with @rent
  end

  def update
    if @rent.update_with_authorization(rent_params, current_user)
      flash[:notice] = 'Bokningen uppdaterades'
      redirect_to edit_rent_path(@rent)
    else
      render action: :edit
    end
  end

  def destroy
    @rent.destroy
    flash[:notice] = 'Bokningen raderades'
    redirect_to :bil
  end

  # Index page available to logged in users.
  def index
    if (current_user)
      @rents = current_user.profile.rents.order('d_from desc')
      render action: 'index'
    else
      redirect_to(action: 'main')
    end
  end

  # Renders with .js and show the form if access is allowed
  def authorize
    @authenticated = @rent.authorize(rent_params[:access_code])
  end

  private
  # Set the @rent to the current object and redirects back to car if it is not found
  def set_rent
    @rent = Rent.find_by_id(params[:id])
    if (@rent == nil)
      flash[:notice] = 'Hittade ingen bilbokning med det ID:t.'
      redirect_to(:bil)
    end
  end

  # @rents: used to show rents under the form when creating new.
  def set_rents
    id = params[:id] || nil
    @rents = Rent.active.date_overlap(Time.zone.now, Time.zone.now+30.days, id).limit(10).ascending
  end

  def rent_params
    params.require(:rent).permit(:d_from, :d_til, :name, :lastname, :email, :phone,
                                 :purpose, :disclaimer, :council_id, :comment, :access_code)
  end
end