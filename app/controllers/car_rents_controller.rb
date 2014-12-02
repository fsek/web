# encoding:UTF-8
class CarRentsController < ApplicationController  
  before_filter :authenticate, only: [:show]
  before_action :set_edit
  before_action :set_rent
  def main
  end
  def new
    @rent = Rent.new
    if(current_user)
      @profile = current_user.profile
      @rent.name = @profile.name
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
      if(current_user) && ( (current_user.profile == @rent.profile)) || (current_user.moderator?(:bil)) 
      else
        redirect_to(:bil)
      end
    else
      flash[:error] = 'Hittade ingen bokning med ID ' + params[:id]+'.'
      redirect_to(:bil)
    end
    rescue ActionController::RedirectBackError
      redirect_to root_path           
  end
  def edit
    @profile = @rent.profile
    @utskott = []
      for @post in @profile.posts do
        if @post.car_rent == true
          @utskott << @post.council
        end
      end     
  end
  def create
    @rent = Rent.new(rent_params)
    if (current_user)
      @rent.profile = current_user.profile
      @rent.confirmed = true
    end    
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
  def bokningar    
    @rents = Rent.all    
    respond_to do |format|
      format.html # bokningar.html.erb
      format.json { render :json => @rents }
    end  
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
        params.require(:rent).permit(:d_from,:d_til,:name,:lastname,:email,:phone,:purpose,:disclaimer,:council_id,:confirmed)
      end
end
