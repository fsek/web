# encoding:UTF-8
class ElectionsController < ApplicationController
  
  before_filter :authenticate_user!, except: [:index] 
  before_filter :authenticate, only: [:new, :create,:edit,:destroy,:update]
  before_filter :no_election, only: [:nominate,:create_nomination,:candidate]
    
  before_action :set_election, except: [:index,:new,:create,:nominate,:candidate,:create_nomination,:create_candidate]
  before_action :set_state, only: [:index,:new,:nominate,:candidate,:create_nomination,:create_candidate]
  

  
  def index
    if(current_user) && (current_user.moderator?(:val))
      @edit = true
    end
    @valet = Election.current
    if(@valet.instance_of?(Election))   
      @datum = (@valet.start > DateTime.now) ? @valet.start : @valet.end
      @poster = @valet.posts
      if (@after)
        @grid_election = initialize_grid(@poster.where(elected_by: "Terminsmötet"),order: 'posts.council_id',order_direction: 'asc', name: "election")
        @grid_extern = initialize_grid(@poster.where.not(elected_by: "Terminsmötet"), name: "extern")
      else  
        @grid_election = initialize_grid(@poster.where.not(elected_by: "Studierådet"),order: 'posts.council_id',order_direction: 'asc', name: "election" )      
      end
    else
      @valet = nil
    end        
  end
  
  def show
    @poster = Post.all
    @nominations_grid = initialize_grid(@valet.nominations)
    @candidates_grid = initialize_grid(@valet.candidates)    
  end
  def nominate
    @valet = Election.current    
    if @after
      @poster = @valet.posts.where.not(elected_by: "Terminsmötet").order(:title)
    else
      @poster = @valet.posts.where.not(elected_by: "Studierådet").order(:title)
    end
    @nomination = @valet.nominations.new()    
  end
  def create_nomination
    @valet = Election.current
    @nomination = @valet.nominations.build(nomination_params)
    respond_to do |format|
      if @nomination.save
        @done = true
        ElectionMailer.nominate_email(@nomination).deliver        
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
    @profile = current_user.profile
    @valet = Election.current
    @poster = []
    if @after
      for @post in @valet.posts.where.not(elected_by: "Terminsmötet").order(:title)
        @poster <<@post
      end
    else
      for @post in @valet.posts.where.not(elected_by: "Studierådet").order(:title)
        @poster <<@post
      end
    end
    for @cand in @profile.candidates
      @poster.delete(@cand.post)
    end
    @candidate = @valet.candidates.new()      
    @candidates_grid = initialize_grid(@profile.candidates)
  end
  def create_candidate
    if(params[:commit] == 'Ta bort')
      @profile = current_user.profile
      @candidate_chosen = Candidate.find_by_id(params[:candidate][:candidate_id])
      if(@candidate_chosen) && (@candidate_chosen.profile == @profile)
        @candidate_chosen.destroy                
      end  
        @valet = Election.current
        @candidate = @valet.candidates.new()
        @poster = []       
        for @post in @valet.posts
          @poster <<@post
        end
        for @cand in @profile.candidates
          @poster.delete(@cand.post)
        end
        @candidates_grid = initialize_grid(@profile.candidates)    
        render action: 'candidate'
        
    elsif params[:commit] == 'Kandidera'
      @valet = Election.current
      @profile = current_user.profile
      for cand in @profile.candidates        
        if candidate_params[:post_id].to_s == cand.post_id.to_s          
          redirect_to action: 'candidate'
          return
        end
      end
      @candidate = @valet.candidates.build(candidate_params)
      @candidate.profile = @profile
      @candidates_grid = initialize_grid(@profile.candidates)
      respond_to do |format|
        if @candidate.save
          @done = true
          ElectionMailer.candidate_email(@candidate).deliver        
          format.html { render action: 'candidate' }
          format.json { render action: 'candidate', status: :created, location: @valet }        
        else
          @valet = Election.current        
        @poster = []       
        for @post in @valet.posts
          @poster <<@post
        end
        for @cand in @profile.candidates
          @poster.delete(@cand.post)
        end
        @candidates_grid = initialize_grid(@profile.candidates)        
          format.html { render action: 'candidate' }
          format.json { render json: @candidate.errors, status: :unprocessable_entity }
        end
      end
    end
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


private
  def authenticate
    flash[:error] = t('the_role.access_denied')
    redirect_to(:back) unless current_user.moderator?(:val)    
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end
  
  def no_election      
    redirect_to action: :index unless Election.current.instance_of?(Election)    
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end
  
  def set_election
    @valet = Election.find_by_url(params[:id])            
    if(@valet.instance_of?(Election) == false)
      redirect_to action: :index
    end      
  end
  
  def set_state
    @valet = Election.current      
    if(@valet.instance_of?(Election))
      if (@valet.start > DateTime.now)
        @datum = @valet.start
        @before = true
        @during = false
        @after = false
      elsif(@valet.end > DateTime.now)
        @datum = @valet.start      
        @before = false
        @during = true
        @after = false      
      else
        @datum = nil
        @before = false
        @during = false
        @after = true      
      end
    else
      @datum = nil
    end        
  end 
  def election_params
    params.fetch(:election).permit(:title,:description,:start,:end,:url,:visible,:mail_link,:mail_styrelse_link,:text_before,:text_during,:text_after,:nominate_mail,:candidate_mail,:extra_text,:candidate_mail_star,:post_ids => [])
  end
  
  def nomination_params
    params.fetch('/val/nominera').permit(:name,:email,:motivation,:election_id,:post_id)
  end
  def candidate_params
    params.fetch('/val/kandidera').permit(:profile_id,:post_id,:election_id,:stil_id,:email,:phone,:motivation)
  end  
end