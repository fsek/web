# encoding: UTF-8
class Elections::NominationsController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :set_election

  def new
    @election_view = ElectionView.new(@election)
    @election_view.nomination = @election_view.election.nominations.build

    if params[:post].present?
      @election_view.nomination.post = Post.find_by_id(params[:post])
    end
  end

  def create
    @election_view = ElectionView.new(@election)
    @election_view.nomination = @election_view.election.nominations.build(nomination_params)
    if ElectionService.create_nomination(@election_view.nomination)
      redirect_to new_nominations_path, notice: alert_create(Nomination)
    else
      render :new, status: 422
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

  def nomination_params
    params.require(:nomination).permit(:name, :email, :motivation, :post_id)
  end
end
