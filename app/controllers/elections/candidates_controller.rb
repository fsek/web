# encoding: UTF-8
class Elections::CandidatesController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    election = set_election
    candidates = current_user.candidates.where(election: election)
    @election_view = ElectionView.new(election, candidates: candidates)
  end

  def new
    election = set_election
    candidate = election.candidates.build(user: current_user)
    @election_view = ElectionView.new(election, candidate: candidate)

    if params[:post].present?
      @election_view.candidate.post = Post.find_by_id(params[:post])
    end
  end

  def show
    election = set_election
    candidate = election.candidates.find_by_id!(params[:id])
    @election_view = ElectionView.new(election, candidate: candidate)
  end

  def create
    election = set_election
    candidate = election.candidates.build(candidate_params)
    @election_view = ElectionView.new(election, candidate: candidate)

    if ElectionService.create_candidate(@election_view.candidate, current_user)
      redirect_to candidate_path(@election_view.candidate),
                  notice: alert_create(Candidate)
    else
      render :new, status: 422
    end
  end

  def destroy
    @candidate = Candidate.find(params[:id])
    if ElectionService.destroy_candidate(@candidate)
      redirect_to candidates_path, notice: alert_destroy(Candidate)
    else
      redirect_to candidate_path(@candidate),
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
