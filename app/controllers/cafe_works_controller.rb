class CafeWorksController < ApplicationController
  before_filter :authenticate, only: [:admin]
  before_action :set_cafe_work, only: [:edit,:show,:update]  
  
  def index
  end
  def show
  end
  def new
    @cwork = CafeWork.new
  end
  def edit
  end
  def create
    @cwork = new CafeWork(c_w_params)
    respond_to do |format|
      if @cwork.save
        format.html { redirect_to cafe_work_path(@cwork), notice: 'Cafejobbet skapades, success.' }
        format.json { head: :no_content }
      else
        format.html { render action: 'new' }
        format.json { render json: @cwork.errors, status: :unprocessable_entity }
      end
    end
  end
  def update
    respond_to do |format|    
      if @cwork.update(c_w_params)
        format.html { redirect_to edit_cafe_work_path(@cwork), notice: 'Cafejobbet uppdaterades!'}
        format.json { head: :no_content }        
      else
        format.html { render action: 'edit' }
        format.json { render json: @cwork.errors, status: :unprocessable_entity } 
      end
    end
  end
  def setup
    
  end
  
  
private
    #Till för att se om någon är admin.
    def authenticate
      redirect_to(:cafe_work, alert: t('the_role.access_denied')) unless current_user && current_user.moderator?(:cafejobb)      
      rescue ActionController::RedirectBackError
        redirect_to root_path
    end
  def c_w_params
    params.require(:cafe_work).permit(:work_day,:pass,:profile_id,:council_id,:name,:lastname,:phone,:stil_id,:c_year,:lp) 
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
