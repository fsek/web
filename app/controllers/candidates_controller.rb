# encoding:UTF-8
class CandidatesController < ApplicationController
  
  before_filter :authenticate_user!  
  before_filter :authenticate, only []
  before_action :set_edit
  before_action :set_election
  before_action :set_candidate, except: [:index,:new,:create]
  

  
  def index
    @candidates = @valet.candidates    
  end
  
  def show
        
  end
  
  def new
    @candidate = @valet.candidates.build
    @poster = @valet.posts
  end
  
  def edit
    @poster = @valet.posts
  end
  end
  
  def create
    @candidate = Candidate.new(candidate_params)
    @candidate.profile = current_user.profile
    respond_to do |format|
      if @candidate.save
        format.html { redirect_to elections_path, notice: 'Du har kandiderat.' }
        format.json { render action: 'show', status: :created, location: @candidate }
      else
        format.html { render action: 'new' }
        format.json { render json: @candidate.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @candidate.update(candidate_params)
        format.html { redirect_to edit_election_candidate_path(@valet,@candidate), notice: 'Kandidering uppdaterades, gött' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @candidate.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @candidate.destroy
    respond_to do |format|
      format.html { redirect_to elections_path,notice: 'Kandideringen raderades, hoppas att det var meningen!.' }
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
    def set_edit
      if(current_user) && (current_user.moderator?(:val))
        @edit = true
      else
        @edit = false
      end
    end
    def set_candidate
    # Use callbacks to share common setup or constraints between actions.
    def set_election
      @valet = Election.find_by_url(params[:election_id])
      if(@valet == nil)
        @valet = Election.find_by_id(params[:election_id])
      if(@valet ==nil)
        @valet = Election.new()
      end      
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def candidate_params
      params.fetch(:candidate).permit(:motivation,:post_id,:profile_id)
    end
end

