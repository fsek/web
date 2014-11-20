# encoding:UTF-8
class CarRentsController < ApplicationController  
  def main
  end
  def new
    @rent = Rent.new
    @profile = current_user.profile
    @rent.name = @profile.name
    @rent.phone = @profile.phone
    @rent.email = @profile.email    
  end
  def show
    @rent = Rent.find_by_id(params[:id])
  end
  def edit
     @rent = Rent.find_by_id(params[:id])
  end
  def create
    @rent = Rent.new(rent_params)
    @rent.profile = current_user.profile    
    respond_to do |format|
      if @rent.save
        format.html { redirect_to [:car,@rent], :notice => 'Bokningen skapades!.' }
        format.json { render :json => @rent, :status => :created, :location => @rent }
      else
        @rent.disclaimer = false
        format.html { render :action => "new" }
        format.json { render :json => @rent.errors, :status => :unprocessable_entity }
      end
    end
  end
  def bokningar    
    @rents = Rent.all    
    respond_to do |format|
      format.html # bokningar.html.erb
      format.json { render :json => @rents }
    end  
  end
  def index
    @bokningar = current_user.profile.rents.order('d_from asc')
  end
  
  def booking
    
  end
  private
    def authenticate
        flash[:error] = t('the_role.access_denied')
        redirect_to(:kalender) unless current_user && current_user.moderator?(:bil)
        
        rescue ActionController::RedirectBackError
          redirect_to root_path
      end
    def rent_params
        params.require(:rent).permit(:from,:til,:name,:lastname,:email,:phone,:purpose,:disclaimer,:council_id)
      end
end
