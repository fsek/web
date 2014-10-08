# encoding:UTF-8
class ElectionsController < ApplicationController
  
  before_filter :authenticate_user!, except: [:index] 
  before_filter :authenticate, only: [:new, :create,:edit,:destroy,:update]
  before_action :set_edit
  before_action :set_election, except: [:index,:new,:create,:nominate,:candidate]
  before_action :set_state, only: [:index,:show,:new,:nominate,:candidate,:create_nomination]
  

  
  def index
    @valet = Election.current
    if(@valet.instance_of?(Election))   
      @datum = (@valet.start > DateTime.now) ? @valet.start : @valet.end
      @poster = @valet.posts
      @election_post_grid = initialize_grid(@poster)
    end        
  end
  
  def show
    @poster = Post.all
    @nominations_grid = initialize_grid(@valet.nominations)
    @candidates_grid = initialize_grid(@valet.candidates)    
  end
  def nominate
    @valet = Election.current
    @poster = @valet.posts
    @nomination = Nomination.new()    
  end
  def create_nomination
    @valet = Election.current
    @nomination = @valet.nominations.build(nomination_params)
    respond_to do |format|
      if @nomination.save
        @done = true        
        format.html { render action: 'nominate' }
        format.json { render action: 'nominate', status: :created, location: @valet }        
      else
        @valet = Election.current
        @poster = @valet.posts        
        format.html { render action: 'nominate' }
        format.json { render json: @nomination.errors, status: :unprocessable_entity }
      end
    end
  end
  def candidate
    @valet = Election.current
  end
  def new
    @valet = Election.new
    @poster = Post.all
  end
  
  def edit
    @poster = Post.all    
  end
  
  
  def create
    @valet = Election.new(election_params)
    respond_to do |format|
      if @valet.save
        format.html { redirect_to elections_path, notice: 'Ett nytt val har skapats!.' }
        format.json { render action: 'show', status: :created, location: @valet }
      else
        format.html { render action: 'new' }
        format.json { render json: @valet.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @valet.update(election_params)
        if election_params[:title] == nil
          format.html { redirect_to edit_election_path(@valet), notice: 'Valet uppdaterades, gött' }
        else
          format.html { redirect_to election_path(@valet), notice: 'Valet uppdaterades, gött' }
        end
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @valet.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @valet.destroy
    respond_to do |format|
      format.html { redirect_to elections_path,notice: 'Valet raderades, hoppas att det var meningen!.' }
      format.json { head :no_content }
    end
  end
end
  private
    def authenticate
      flash[:error] = t('the_role.access_denied')
    redirect_to(:back) unless current_user.moderator?(:val)
    
    rescue ActionController::RedirectBackError
      redirect_to root_path
    end
    def set_edit
      if(current_user) && (current_user.moderator?(:val))
        @edit = true
      else
        @edit = false
      end
    end
    def set_state
      @valet = Election.current      
      if(@valet.instance_of?(Election))
        if (@valet.start > DateTime.now)
          @datum = @valet.start
          @before = true
        elsif(@valet.end > DateTime.now)
          @datum = @valet.start      
          @during = true      
        else
          @datum = nil
          @after = true      
        end
      else
        @datum = nil        
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_election
      @valet = Election.find_by_url(params[:id])
      if(@valet == nil)
        @valet = Election.find_by_id(params[:id])
      end
      if(@valet ==nil)
        @valet = nil
      end      
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def election_params
      params.fetch(:election).permit(:title,:description,:start,:end,:url,:visible,:text_before,:text_during,:text_after,:nominate_mail,:candidate_mail,:post_ids => [])
    end
    def nomination_params
    params.fetch('/val/nominera').permit(:name,:email,:stil_id,:phone,:motivation,:election_id,:post_id)
    end
end
