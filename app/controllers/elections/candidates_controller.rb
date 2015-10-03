# encoding: UTF-8
class Elections::CandidatesController < ApplicationController
  before_action :set_election
  load_permissions_and_authorize_resource

  def index
    @candidates = current_user.candidates.where(election: @election)
    @candidates_grid = initialize_grid(@candidates)
  end

  def new
    @candidate = @election.candidates.new
    @candidate.user = current_user
    if params[:post].present?
      @candidate.post = Post.find_by_id(params[:post])
    end
  end

  def show
  end

  def create
    @candidate = @election.candidates.build(candidate_params)

    if ElectionService.create_candidate(@candidate, current_user)
      redirect_to candidate_path(@candidate), notice: alert_create(Candidate)
    else
      render action: :new
    end
  end

  def update
    if @candidate.update(candidate_params)
      redirect_to candidate_path(@candidate), notice: alert_update(Candidate)
    else
      render action: :show
    end
  end

  def destroy
    if ElectionService.destroy_candidate(@candidate)
      redirect_to candidates_path, notice: alert_destroy(Candidate)
    else
      redirect_to candidate_path(@candidate),
                  notice: %(#{model_name(Candidate)} #{t(:not_allowed_destroy)}.)
    end
  end

  private

  def set_election
    @election = Election.current
  end

  def candidate_params
    params.require(:candidate).permit(:post_id, :user_id)
  end
end
