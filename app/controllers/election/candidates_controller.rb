# encoding: UTF-8
class Election::CandidatesController < ApplicationController
  before_action :login_required
  before_action :set_election
  before_action :set_candidate, only: [:show,:update,:destroy]


  def index
    @candidates = current_user.profile.candidates.where(election: @election)
    @candidates_grid = initialize_grid(@candidates)
  end
  def new
    @candidate = @election.candidates.new
    @candidate.prepare(current_user)
    if params[:post].present?
      @candidate.post = Post.find_by_id(params[:post])
    end
  end
  def show

  end
  def create
    @candidate = @election.candidates.build(candidate_params)
    @candidate.profile = current_user.profile
    respond_to do |format|
      if @candidate.save
        format.html { redirect_to election_candidates_path, notice: 'Kandidaturen skapades, success.' }
        format.json { render action: 'index', status: :created, location: @candidate }
      else
        format.html { render action: 'new' }
        format.json { render json: @candidate.errors, status: :unprocessable_entity }
      end
    end
  end
  def update
    respond_to do |format|
      if @candidate.update(candidate_params)
        format.html { redirect_to election_candidate_path(@candidate), notice: 'Kandidaturen uppdaterades, toppen.' }
        format.json { render action: 'show', status: :created, location: @candidate }
      else
        format.html { render action: 'show' }
        format.json { render json: @candidate.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @candidate.destroy
    respond_to do |format|
      format.html { redirect_to election_candidates_path,notice: 'Kandidaturen raderades.' }
      format.json { head :no_content }
    end
  end

  private
  def set_candidate
    @candidate = Candidate.find_by_id(params[:id])
    if current_user.present? && current_user.profile != @candidate.profile
      redirect_to(elections_path)
      flash[:notice] = 'Du har inte rättigheter för att se kandidaturen.'
    end
  end

  def set_election
    @election = Election.current
  end
  def candidate_params
    params.require(:candidate).permit(:profile_id,:post_id,:stil_id,:email,:phone,:motivation, :name,:lastname)
  end

end
