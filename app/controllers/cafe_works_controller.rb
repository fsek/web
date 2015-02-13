class CafeWorksController < ApplicationController
  before_filter :authenticate, only: [:admin]
  before_action :set_cafe_work, only: [:edit,:show,:update,:destroy]
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
          if(@cwork.profile_id.nil?) && (@cwork.access_code.nil?)
            @cwork.update(access_code: (0...15).map { (65 + rand(26)).chr }.join.to_s)
            @print = "Du är nu uppskriven för att jobba på passet, du använder koden "+ @cwork.access_code + " för att redigera din bokning, du har även fått mejl."
            #Skicka mejl! 
          elsif(@cwork.profile_id.nil?)
            @print = "Dina uppgifter sparades och du är uppskriven för att arbeta på passet"
          end
          
          format.html { redirect_to cafe_work_path(@cwork), notice: @print}
          format.json { head :no_content }        
        else
          format.html { render action: 'edit' }
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
          format.html { render action: 'edit' }
          format.json { render json: @cwork.errors, status: :unprocessable_entity } 
        end
      end
    end
  end
  def destroy    
    @cwork.destroy
    respond_to do |format|
      format.html { redirect_to :hilbert,notice: 'Cafepasset raderades.' }
      format.json { head :no_content }
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
          @cworks << CafeWork.new(work_day: wday, lp: lp,pass: 1,lv: week, d_year: wday.year)
          @cworks << CafeWork.new(work_day: wday, lp: lp,pass: 2,lv: week, d_year: wday.year)
          @cworks << CafeWork.new(work_day: wday+2.hours, lp: lp,pass: 3, lv: week, d_year: wday.year)
          @cworks << CafeWork.new(work_day: wday+2.hours, lp: lp,pass: 4, lv: week, d_year: wday.year)
          wday = wday + 1.days
        end
        wday = wday + 2.days
      end
      @cwork = CafeWork.new(c_w_params)
      render action: 'setup'
     elsif(params[:commit] == "Skapa")
      wday = DateTime.new(params[:cafe_work]["work_day(1i)"].to_i, params[:cafe_work]["work_day(2i)"].to_i ,params[:cafe_work]["work_day(3i)"].to_i, params[:cafe_work]["work_day(4i)"].to_i-1,0)    
      lp = params[:cafe_work][:lp]    
      (1..7).each do |week|             
        (0..4).each do        
          CafeWork.new(work_day: wday, lp: lp,pass: 1,lv: week, d_year: wday.year).save
          CafeWork.new(work_day: wday, lp: lp,pass: 2,lv: week, d_year: wday.year).save
          CafeWork.new(work_day: wday+2.hours, lp: lp,pass: 3, lv: week, d_year: wday.year).save
          CafeWork.new(work_day: wday+2.hours, lp: lp,pass: 4, lv: week, d_year: wday.year).save
          wday = wday + 1.days
        end
        wday = wday + (2).days
      end
      redirect_to action: 'main'
     end      
  end
  def main
  end
  def nyckelpiga    
    if(params[:date])
      @date = Date.new(params[:date][:year].to_i,params[:date][:month].to_i,params[:date][:day].to_i)
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
          @profiles[work.profile_id] == {@count}
        end
      end
    
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
