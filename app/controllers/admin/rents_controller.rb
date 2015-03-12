class Admin::RentsController < ApplicationController
  before_action :login_required
  before_action :authenticate
  before_action :set_rent, only: [:show, :update, :edit]
  before_action :set_rents, only: [:edit, :new]
  before_action :set_councils, only: [:new, :edit]

  def main
    @rents = Rent.ascending.from_date(Time.zone.now.beginning_of_day)
    @rent_grid = initialize_grid(@rents)
    @faqs = Faq.where(answer: '').where(category: 'Bil')
  end

  def show
  end

  def edit
  end

  def create
    @rent = Rent.new_with_status(rent_params, nil)
    respond_to do |format|
      if @rent.save(validate: false)
        format.html {
          redirect_to admin_rent(@rent), notice: 'Bokningen skapades, mejl har skickats till angiven epostadress!'
        }
        format.json { render json: @rent, status: :created, location: @rent }
      else
        format.html { render action: "new" }
        format.json { render json: @rent.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @rent = Rent.new
  end

  def update
    respond_to do |format|
      if @rent.update_without_validation(rent_params)
        format.html { redirect_to edit_admin_rent_path(@rent), notice: 'Bokningen uppdaterades.' }
        format.json { render json: @rent, status: :created, location: @rent }
      else
        format.html { render action: "edit" }
        format.json { render json: @rent.errors, status: :unprocessable_entity }
      end
    end
  end

  def authenticate
    flash[:error] = t('the_role.access_denied')
    redirect_to(:back) unless (current_user) && (current_user.moderator?(:bil))
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  # Makes sure that an event is found, otherwise redirects to admin page
  def set_rent
    @rent = Rent.find_by_id(params[:id])
    if (@rent == nil)
      flash[:notice] = 'Hittade ingen bilbokning med det ID:t.'
      redirect_to(:admin_car)
    end
  end

  # @rents is used for showing already booked rents
  def set_rents
    id = params[:id] || nil
    @rents = Rent.active.date_overlap(Time.zone.now, Time.zone.now+30.days, id).limit(10).ascending
  end

  # To set the councils
  def set_councils
    @councils = Council.all
  end

  def rent_params
    params.require(:rent).permit(:d_from, :d_til, :name, :lastname, :email, :phone, :purpose, :disclaimer, :council_id, :comment, :access_code, :status, :aktiv, :comment)
  end
end
