# encoding:UTF-8
class CafeWorksController < ApplicationController
  before_filter :authenticate, only: [:admin]
  before_action :set_cafe_work, only: [:show,:update,:destroy,:remove_worker]
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
    @readonly = (@cwork.work_day < DateTime.now)
    Rails.logger.info @readonly
    @utskott = Council.all    
    #@faddergrupper
  end
  def update
    @utskott = Council.all
    if(params[:commit] == "Auktorisera")
      if(!@cwork.access_code.nil?) && (params[:cafe_work][:access_code] == @cwork.access_code)
        @authenticated = true
        flash[:notice] = "Koden var rätt, du kan nu redigera"
        render action: :show        
      else
        flash[:alert] = "Ogiltlig kod, om du tror något är fel, kontakta Cafemästare eller Spindelmän"
        render action: :show
      end
    elsif(params[:commit] == "Spara")
      respond_to do |format|    
        if @cwork.update(c_w_params)
          print = @cwork.at_update
          format.html { redirect_to cafe_work_path(@cwork), notice: print}
          format.json { head :no_content }        
        else
          format.html { render action: 'show' }
          format.json { render json: @cwork.errors, status: :unprocessable_entity } 
        end
      end
    elsif(params[:commit] == "Lämna jobbpasset")      
      respond_to do |format|    
        if @cwork.update(name: nil, lastname: nil,profile_id: nil, phone: nil, email: nil,utskottskamp: false, access_code: nil)
          @cwork.councils.clear
          format.html { redirect_to cafe_work_path(@cwork), notice: 'Du jobbar inte längre på cafepasset!'}
          format.json { head :no_content }        
        else
          format.html { render action: 'show' }
          format.json { render json: @cwork.errors, status: :unprocessable_entity } 
        end
      end
    end
  end
  def remove_worker       
    if !@cwork.update(name: nil, lastname: nil,profile_id: nil, phone: nil, email: nil,utskottskamp: false, access_code: nil)
        render action: show, notice: "Lyckades inte"
    end
    @cwork.councils.clear
    #skicka mejl?
  end  
  def main
     @faqs = Faq.where(category: :Hilbert).where.not(answer: '')
     @lv = CafeWork.where(work_day: DateTime.now.beginning_of_day-2.days..DateTime.now.end_of_day).last.lv
               
  end
  def nyckelpiga    
    if(params[:date])
      @date = Date.parse(params[:date] )
      @works = CafeWork.where(work_day: @date..@date+1.days).order(pass: :asc)
    else
      @date = Date.today
      @works = CafeWork.where(work_day: DateTime.now.beginning_of_day..DateTime.now.end_of_day).order(pass: :asc)
    end    
    @work_grid = initialize_grid(@works)
  end
  def tavling
    if(params[:lp])
      @LP = params[:lp]
    else
      @LP = CafeWork.where(work_day: DateTime.now-10.days..DateTime.now+10.days).limit(1).first.lp
    end    
      @works = CafeWork.where(work_day: DateTime.now-100.days..DateTime.now, lp: @LP)
      @profiles = {}
      @works.each do |work|
        if work.profile_id
          @count = CafeWork.where(lp:3,d_year: 2015, profile_id: work.profile_id, work_day: DateTime.now-50.days..DateTime.now).count
          @profiles[work.profile_id] == @count
        end
      end    
  end
  
  
private
  def set_mod
    if(current_user) && (current_user.moderator?(:cafejobb))
      @mod = true
    end    
  end
  def c_w_params
    params.require(:cafe_work).permit(:work_day,:pass,:profile_id,:name,:lastname,:phone,:email,:lp,:utskottskamp,:council_ids => []) 
  end  
  def set_cafe_work
    @cwork = CafeWork.find_by_id(params[:id])
    if(@cwork == nil)     
        flash[:notice] = 'Hittade inget Cafejobb med det ID:t.'
        redirect_to(:hilbert)        
      end      
      rescue ActionController::RedirectBackError
      redirect_to root_path      
  end
end
