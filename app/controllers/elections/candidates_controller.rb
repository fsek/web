# encoding: UTF-8
class Elections::CandidatesController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    election = set_election
    candidates = current_user.candidates.where(election: election)
    @candidate_view = CandidateView.new(election, all: candidates)
  end

  def new
    election = set_election
    candidate = election.candidates.build(user: current_user)
    @candidate_view = CandidateView.new(election, current: candidate)

    if params[:post].present?
      @candidate_view.current.post = Post.find_by_id(params[:post])
    end
  end

  def show
    election = set_election
    candidate = election.candidates.find_by_id!(params[:id])
    @candidate_view = CandidateView.new(election, current: candidate)
  end

  def create
    election = set_election
    candidate = election.candidates.build(candidate_params)
    @candidate_view = CandidateView.new(election, current: candidate)

    if ElectionService.create_candidate(@candidate_view.current, current_user)
      redirect_to candidate_path(@candidate_view.current),
                  notice: alert_create(Candidate)
    else
      render :new, status: 422
    end
  end

  def destroy
    candidate = Candidate.find(params[:id])
    if ElectionService.destroy_candidate(candidate)
      redirect_to candidates_path, notice: alert_destroy(Candidate)
    else
      redirect_to candidate_path(candidate),
                  notice: %(#{model_name(Candidate)} #{t(:not_allowed_destroy)}.)
    end
  end

  private

  def set_election
    election = Election.current
    if election.nil?
      render '/elections/no_election', status: 422
    else
      election
    end
  end

  def candidate_params
    params.require(:candidate).permit(:post_id)
  end
end
