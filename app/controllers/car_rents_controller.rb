# encoding:UTF-8
class CarRentsController < ApplicationController  
  before_filter :authenticate, only: [:forman]
  before_action :set_edit
  before_action :set_rent
  def main
    @bokningar = Rent.order(d_from: :asc).where.not(status: "nekad").where(d_from: Date.today..Date.today+30)
    respond_to do |format|      
        format.html 
        format.json { render :json => @bokningar}
    end 
  end
  def new
    @rents = Rent.order(d_from: :asc).where(d_from: Date.today..Date.today+30).limit(10).where.not(status: "Nekad")
    @avtal = Document.where(title: "Bilavtal").first
    @rent = Rent.new
    if(current_user)
      @profile = current_user.profile
      @rent.name = @profile.name
      @rent.lastname = @profile.lastname
      @rent.phone = @profile.phone
      @rent.email = @profile.email
      @utskott = []
      for @post in @profile.posts do
        if @post.car_rent == true
          @utskott << @post.council
        end
      end
    end    
  end
  def show
    if(@rent != nil)
      if(current_user) && (current_user.profile == @rent.profile) 
      elsif(current_user) && (current_user.moderator?(:bil))
      else
        redirect_to(:bil)
        flash[:notice] = 'Du har inte rättigheter för att se bokningen.'
      end
    else
      flash[:notice] = 'Hittade ingen bokning med ID ' + params[:id]+'.'
      redirect_to(:bil)
    end
    rescue ActionController::RedirectBackError
      redirect_to root_path           
  end
  def edit
    @rents = Rent.order(d_from: :asc).where(d_from: Date.today..Date.today+30).limit(10).where.not(status: "Nekad").where.not(id: @rent.id)
    if @rent.profile
      @profile = @rent.profile
      @utskott = []
      for @post in @profile.posts do
        if @post.car_rent == true
          @utskott << @post.council
        end
      end
    end
  end
  def create
    @rent = Rent.new(rent_params)
    if (current_user)
      @rent.profile = current_user.profile
      @rent.status = "Bekräftad"
    end    
    respond_to do |format|
      if @rent.save
        CarRentMailer.rent_email(@rent).deliver
        format.html { redirect_to [:car,@rent], :notice => 'Bokningen skapades!.' }
        format.json { render :json => @rent, :status => :created, :location => @rent }
      else
        @rent.disclaimer = false
        format.html { render :action => "new" }
        format.json { render :json => @rent.errors, :status => :unprocessable_entity }
      end
    end
  end
  def update           
    respond_to do |format|
      if params[:rent][:confirmed] == true
        Rails.logger.info @rent.update_attribute(:confirmed,true)
      else
        
        if @rent.update(rent_params) 
          format.html { redirect_to [:car,@rent], :notice => 'Bokningen sparades.' }
          format.json { render :json => @rent, :status => :created, :location => @rent }
        else        
          format.html { render :action => "edit" }
          format.json { render :json => @rent.errors, :status => :unprocessable_entity }
        end
      end
    end
  end
  def destroy    
    @rent.destroy
    respond_to do |format|
      format.html { redirect_to car_rents_path,notice: 'Bokningeng raderades.' }
      format.json { head :no_content }
    end
  end
  def forman    
    @rents = Rent.order(d_from: :asc).where(d_from: Date.today..Date.today+30)
    @rent_grid = initialize_grid(@rents)
  end
  def index
    if (current_user)
      @bokningar = current_user.profile.rents.order('d_from asc')
      render :action => 'user_index'
    else
      render :action => 'guest_index'
    end
  end
  
  def booking
    
  end
  private
    def authenticate            
      flash[:error] = t('the_role.access_denied')
      redirect_to(:bil) unless current_user && current_user.moderator?(:bil)      
      rescue ActionController::RedirectBackError
        redirect_to root_path
    end
    def set_rent
      @rent = Rent.find_by_id(params[:id])
    end
    def set_edit
      if(@rent) && (current_user) && (current_user.profile == @rent.profile)
        @edit = true
      end
      if(current_user) && (current_user.moderator?(:bil))
        @mod = true
      end
    end
    def rent_params
        params.require(:rent).permit(:d_from,:d_til,:name,:lastname,:email,:phone,:purpose,:disclaimer,:council_id,:status,:aktiv, :comment)
      end
end
