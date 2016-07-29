# encoding: UTF-8
class Elections::CandidatesController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :set_election

  def index
    @election_view = ElectionView.new(@election)
    candidates = current_user.candidates.where(election: @election_view.election)
    if candidates.any?
      @election_view.grid = initialize_grid(candidates, order: :created_at,
                                                        include: [:position, :election])
    end
  end

  def new
    candidate = @election.candidates.build(user: current_user)
    @election_view = ElectionView.new(@election, candidate: candidate)

    if params[:position].present?
      @candidate_view.current.position = Position.find_by_id(params[:position])
    end
  end

  def create
    candidate = @election.candidates.build(candidate_params)
    @election_view = ElectionView.new(@election, candidate: candidate)

    if ElectionService.create_candidate(@election_view.candidate, current_user)
      redirect_to candidates_path,
                  notice: alert_create(Candidate)
    else
      render :new, status: 422
    end
  end

  def destroy
    candidate = @election.candidates.find(params[:id])
    if ElectionService.destroy_candidate(candidate)
      redirect_to candidates_path, notice: alert_destroy(Candidate)
    else
      redirect_to candidates_path,
                  notice: %(#{model_name(Candidate)} #{t('model.candidate.not_allowed_to_destroy')}.)
    end
  end

  private

  def set_election
    @election = Election.current
    if @election.nil?
      render '/elections/no_election', status: 404
    else
      @election
    end
  end

  def candidate_params
    params.require(:candidate).permit(:position_id)
  end
end
