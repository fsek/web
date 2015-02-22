# encoding:UTF-8
class CafeWorksController < ApplicationController  
  before_action :set_cafe_work, except: [:main,:nyckelpiga]
  before_action :set_mod, only: [:show,:main,:nyckelpiga]
  before_action :councils, except: [:main,:nyckelpiga,:tavling]
  before_action :nyckelpiga_auth, only: :nyckelpiga
    
  def show
    @utskott = Council.all
    @readonly = (@cwork.work_day < DateTime.now)  
    if user_signed_in?
      @profile = current_user.profile
      @cwork.load(@profile)
    end    
    @status = @cwork.status_text(current_user)
    #@faddergrupper
  end
  def authorize        
    @authenticated = @cwork.authorize(worker_params[:access_code])
  end
  def update
    @utskott = Council.all
    respond_to do |format|
      if !current_user.nil?
        profile = current_user.profile
      end
      if @cwork.update_worker(worker_params,profile)        
        format.html { redirect_to cafe_work_path(@cwork), notice: @cwork.status}
        format.json { head :no_content }        
      else
        format.html { render :show, alert: @cwork.status }
        format.json { render json: @cwork.errors, status: :unprocessable_entity }
      end
    end
  end  
  def remove_worker       
    profile = (current_user) ? current_user.profile : nil
    if(profile.nil?)
      access = worker_params[:access_code]
    end
    @removed = @cwork.worker_remove(profile,access)
  end  
  def main     
     respond_to do |format|
      format.html {
        @faqs = Faq.where(category: :Hilbert).where.not(answer: '')
        @lv = CafeWork.where(work_day: DateTime.now.beginning_of_day-2.days..DateTime.now.end_of_day).last.lv
      }
      format.json {render json: CafeWork.where(work_day: params[:start]..params[:end])}
    end     
               
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
  # Icke-använd kod för cafetävlingen
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
    @mod = true if current_user && current_user.moderator?(:hilbert)
  end
  def nyckelpiga_auth    
    if(current_user)
      post = Post.where(title: "Nyckelpiga").includes(:profiles).where(profiles: { id: current_user.profile.id}).first
    end
    if(post.nil?) && !((current_user) && (current_user.moderator?(:hilbert)))
      redirect_to(:hilbert, alert: "Du saknar behörighet")        
    end
    rescue ActionController::RedirectBackError
    redirect_to root_path
  end
  def worker_params
    params.require(:cafe_work).permit(:profile_id,:name,:lastname,:phone,:email,:lp,:utskottskamp, :access_code, :council_ids => []) 
  end
  def councils
    @utskott = Council.all
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
