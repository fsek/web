# encoding: UTF-8
class Elections::CandidatesController < ApplicationController
  before_action :set_election
  load_permissions_and_authorize_resource
  respond_to :html

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
    if @candidate.save
      flash[:notice] = 'Kandidaturen skapades.'
      redirect_to @candidate
    else
      render action: :new
    end
  end

  def update
    if @candidate.update(candidate_params)
      flash[:notice] = 'Kandidaturen uppdaterades'
      redirect_to @candidate
    else
      render action: :show
    end
  end

  def destroy
    @candidate.destroy
    flash[:notice] = 'Kandidaturen raderades'
    redirect_to candidates_path
  end

  private

  def set_election
    @election = Election.current
  end

  def candidate_params
    params.require(:candidate).permit(:profile_id, :post_id, :stil_id,
                                      :email, :phone, :name, :lastname)
  end

end