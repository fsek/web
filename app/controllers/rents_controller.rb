# encoding:UTF-8
class RentsController < ApplicationController
  before_action :set_rents, only: [:new, :edit, :create, :update,:authorize]
  before_action :set_rent, only: [:show,:edit,:update,:authorize]

  def main
    @faqs = Faq.answered.category('Bil')
    respond_to do |format|
      format.html
      format.json { render json: Rent.between(params[:start],params[:end]).active }
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
    respond_to do |format|
      if @rent.save
        if (current_user)
          format.html { redirect_to @rent, notice: 'Bokningen skapades!' }
        else
          format.html { redirect_to @rent, notice: 'Bokningen skapades, du ska ha fått ett mejl till angiven epostadress (möjligen i skräppost)!' }
        end
        format.json { render json: @rent, status: :created, location: @rent }
      else
        format.html { render action: "new" }
        format.json { render json: @rent.errors, status:  :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @rent.update_with_authorization(rent_params,current_user)
        format.html { redirect_to edit_rent_path(@rent), notice: 'Bokningen uppdaterades.' }
        format.json { render json: @rent, status: :created, location:  @rent }
      else
        format.html { render action: "edit"}
        format.json { render json: @rent.errors, status:  :unprocessable_entity }
      end
    end
  end

  def destroy
    @rent.destroy
    respond_to do |format|
      format.html { redirect_to :bil, notice: 'Bokningen raderades.' }
      format.json { head :no_content }
    end
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

  def authorize
    @authenticated = @rent.authorize(rent_params[:access_code])
  end

  private
  #Ser till att ett Rent-objekt hittas för det ID som kommer i parametern, annars gör den redirect.
  def set_rent
    @rent = Rent.find_by_id(params[:id])
    if (@rent == nil)
      flash[:notice] = 'Hittade ingen bilbokning med det ID:t.'
      redirect_to(:bil)
    end
  end

  #@rents används t.ex. för att visa andra bokningar när man själv gör sin bokning
  def set_rents
    id = params[:id] || nil
    @rents = Rent.active.date_overlap(Time.zone.now, Time.zone.now+30.days, id).limit(10).ascending
  end

  def rent_params
    params.require(:rent).permit(:d_from, :d_til, :name, :lastname, :email, :phone, :purpose, :disclaimer, :council_id, :comment, :access_code)
  end
end
