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
    @candidate.user = current_user
    if @candidate.save
      flash[:notice] = %(#{model_name(Candidate, 1)} #{t(:success_create)}.)
      redirect_to candidate_path(@candidate)
    else
      render action: :new
    end
  end

  def update
    if @candidate.update(candidate_params)
      flash[:notice] = %(#{model_name(Candidate, 1)} #{t(:success_update)}.)
      redirect_to candidate_path(@candidate)
    else
      render action: :show
    end
  end

  def destroy
    if @candidate.editable?
      @candidate.destroy
      flash[:notice] = %(#{model_name(Candidate, 1)} #{t(:success_destroy)}.)
    else
      flash[:notice] = %(#{model_name(Candidate, 1)} #{t(:not_allowed_destroy)}.)
    end
    redirect_to candidates_path
  end

  private

  def set_election
    @election = Election.current
  end

  def candidate_params
    params.require(:candidate).permit(:post_id)
  end
end
