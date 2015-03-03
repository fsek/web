# encoding:UTF-8
class Admin::CafeWorksController < ApplicationController  
  before_filter :authenticate
  before_action :set_cafe_work, only: [:edit,:show,:update,:destroy,:remove_worker]
  
  def show
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
    respond_to do |format|         
      if @cwork.update(c_w_params)        
        format.html { redirect_to cafe_work_path(@cwork), notice: "Passet uppdaterades"}
        format.json { head :no_content }        
      else
        format.html { render action: 'edit' }
        format.json { render json: @cwork.errors, status: :unprocessable_entity }
        format.js 
      end
    end    
  end
  def destroy 
    @id = @cwork.id 
    @cwork.destroy
    respond_to do |format|
      format.html { redirect_to :hilbert,notice: 'Cafepasset raderades.' }
      format.json { head :no_content }
      format.js
    end
  end
  def remove_worker       
    if !@cwork.clear_worker
        render action: show, notice: "Lyckades inte"
    end        
  end
  def setup
    @cwork = CafeWork.new    
  end
  def setup_preview
    @cworks = []   
      wday = Time.zone.local(params[:cafe_work]["work_day(1i)"].to_i, params[:cafe_work]["work_day(2i)"].to_i ,params[:cafe_work]["work_day(3i)"].to_i, params[:cafe_work]["work_day(4i)"].to_i,0)    
      lp = params[:cafe_work][:lp]
      @lv_first = params[:lv_first].to_i
      @lv_last = params[:lv_last].to_i
      (@lv_first..@lv_last).each do |week|             
        (0..4).each do        
          @cworks << CafeWork.new(work_day: wday, lp: lp,pass: 1,lv: week, d_year: wday.year)
          @cworks << CafeWork.new(work_day: wday, lp: lp,pass: 2,lv: week, d_year: wday.year)
          @cworks << CafeWork.new(work_day: wday+2.hours, lp: lp,pass: 3, lv: week, d_year: wday.year)
          @cworks << CafeWork.new(work_day: wday+2.hours, lp: lp,pass: 4, lv: week, d_year: wday.year)
          wday = wday + 1.days
        end
        wday = wday + 2.days
      end
      @cwork = CafeWork.new(c_w_params)
      render 'setup'
  end
  def setup_create
      wday = Time.zone.local(params[:cafe_work]["work_day(1i)"].to_i, params[:cafe_work]["work_day(2i)"].to_i ,params[:cafe_work]["work_day(3i)"].to_i, params[:cafe_work]["work_day(4i)"].to_i,0)    
      lp = params[:cafe_work][:lp]    
      (params[:lv_first]..params[:lv_last]).each do |week|             
        (0..4).each do        
          CafeWork.create(work_day: wday, lp: lp,pass: 1,lv: week, d_year: wday.year)
          CafeWork.create(work_day: wday, lp: lp,pass: 2,lv: week, d_year: wday.year)
          CafeWork.create(work_day: wday+2.hours, lp: lp,pass: 3, lv: week, d_year: wday.year)
          CafeWork.create(work_day: wday+2.hours, lp: lp,pass: 4, lv: week, d_year: wday.year)
          wday = wday + 1.days
        end
        wday = wday + (2).days
      end
      redirect_to action: 'main'        
  end
  def main            
    @faqs = Faq.where(category: :Hilbert).where.not(answer: '')   
    @faq_unanswered = Faq.where(category: :Hilbert, answer: '').count        
    @cworks = CafeWork.all
    @cwork_grid = initialize_grid(@cworks) 
  end
  
private
  #Till för att se om någon är admin.
  def authenticate
    redirect_to(:hilbert, alert: t('the_role.access_denied')) unless current_user && current_user.moderator?(:cafejobb)      
    rescue ActionController::RedirectBackError
      redirect_to root_path
  end  
  def c_w_params
    params.require(:cafe_work).permit(:work_day,:pass,:profile_id,:name,:lastname,:phone,:email,:lp,:lv,:utskottskamp,:council_ids => []) 
  end
      
  def set_cafe_work
    @cwork = CafeWork.find_by_id(params[:id])
    if(@cwork == nil)     
        flash[:notice] = 'Hittade inget Cafejobb med det ID:t.'
        redirect_to(:admin_cafe_works)        
      end      
      rescue ActionController::RedirectBackError
      redirect_to root_path      
  end
end