class CafeWorksController < ApplicationController
  before_filter :authenticate, only: [:admin]
  before_action :set_cafe_work, only: [:edit,:show,:update]
  before_action :set_mod  
  
  def index
    respond_to do |format|
      format.json {render json: CafeWork.where(work_day: params[:start]..params[:end])}
    end    
  end
  def show
    if not(@cwork.profile) && (user_signed_in?)
      @profile = current_user.profile      
      @cwork.name = @profile.name
      @cwork.lastname = @profile.lastname
      @cwork.email = @profile.email
      @cwork.phone = @profile.phone
    end 
    @utskott = Council.all
    #@faddergrupper
  end
  def new
    @cwork = CafeWork.new
  end
  def edit
  end
  def create
    @cwork = CafeWork.new(c_w_params)
    respond_to do |format|
      if @cwork.save
        format.html { redirect_to cafe_work_path(@cwork), notice: 'Cafejobbet skapades, success.' }
        format.json { head :no_content }
      else
        format.html { render action: 'new' }
        format.json { render json: @cwork.errors, status: :unprocessable_entity }
      end
    end
  end
  def update
    if(params[:commit] == "Spara")
      respond_to do |format|    
        if @cwork.update(c_w_params)
          format.html { redirect_to cafe_work_path(@cwork), notice: 'Cafejobbet uppdaterades!'}
          format.json { head :no_content }        
        else
          format.html { render action: 'edit' }
          format.json { render json: @cwork.errors, status: :unprocessable_entity } 
        end
      end
    elsif(params[:commit] == "Lämna jobbpasset")      
      respond_to do |format|    
        if @cwork.update(name: nil, lastname: nil,profile_id: nil, phone: nil, email: nil,utskottskamp: false)
          @cwork.councils.clear
          format.html { redirect_to cafe_work_path(@cwork), notice: 'Du jobbar inte längre på cafepasset!'}
          format.json { head :no_content }        
        else
          format.html { render action: 'edit' }
          format.json { render json: @cwork.errors, status: :unprocessable_entity } 
        end
      end
    end
   
  end
  def setup
    @cwork = CafeWork.new
  end
  def setup_create
    if(params[:commit] == "Förhandsgranska")    
      @cworks = []   
      wday = DateTime.new(params[:cafe_work]["work_day(1i)"].to_i, params[:cafe_work]["work_day(2i)"].to_i ,params[:cafe_work]["work_day(3i)"].to_i, params[:cafe_work]["work_day(4i)"].to_i-1,0)    
      lp = params[:cafe_work][:lp]    
      (1..7).each do |week|             
        (0..4).each do        
          @cworks << CafeWork.new(work_day: wday, lp: lp,pass: 1,lv: week)
          @cworks << CafeWork.new(work_day: wday, lp: lp,pass: 2,lv: week)
          @cworks << CafeWork.new(work_day: wday+2.hours, lp: lp,pass: 3, lv: week)
          @cworks << CafeWork.new(work_day: wday+2.hours, lp: lp,pass: 4, lv: week)
          wday = wday + 1.days
        end
        wday = wday + (2).days
      end
      @cwork = CafeWork.new(c_w_params)
      render action: 'setup'
     elsif(params[:commit] == "Skapa")
      wday = DateTime.new(params[:cafe_work]["work_day(1i)"].to_i, params[:cafe_work]["work_day(2i)"].to_i ,params[:cafe_work]["work_day(3i)"].to_i, params[:cafe_work]["work_day(4i)"].to_i-1,0)    
      lp = params[:cafe_work][:lp]    
      (1..7).each do |week|             
        (0..4).each do        
          CafeWork.new(work_day: wday, lp: lp,pass: 1,lv: week).save
          CafeWork.new(work_day: wday, lp: lp,pass: 2,lv: week).save
          CafeWork.new(work_day: wday+2.hours, lp: lp,pass: 3, lv: week).save
          CafeWork.new(work_day: wday+2.hours, lp: lp,pass: 4, lv: week).save
          wday = wday + 1.days
        end
        wday = wday + (2).days
      end
      redirect_to action: 'main'
     end      
  end
  def main
  end
  
  
private
  #Till för att se om någon är admin.
  def authenticate
    redirect_to(:cafe_work, alert: t('the_role.access_denied')) unless current_user && current_user.moderator?(:cafejobb)      
    rescue ActionController::RedirectBackError
      redirect_to root_path
  end
  def set_mod
    if(current_user) && (current_user.moderator?(:cafejobb))
      ##@mod = true
    end    
  end
  def c_w_params
    params.require(:cafe_work).permit(:work_day,:pass,:profile_id,:name,:lastname,:phone,:email,:lp,:utskottskamp,:council_ids => []) 
  end  
  def set_cafe_work
    @cwork = CafeWork.find_by_id(params[:id])
    if(@cwork == nil)     
        flash[:notice] = 'Hittade inget Cafejobb med det ID:t.'
        redirect_to(:cafe_works)        
      end      
      rescue ActionController::RedirectBackError
      redirect_to root_path
      
  end
end
