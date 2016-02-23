# encoding: UTF-8
class Elections::NominationsController < ApplicationController
  before_action :set_election
  load_permissions_and_authorize_resource

  def new
    @election_view = ElectionView.new(set_election)
    @election_view.nomination = @election_view.election.nominations.new

    if params[:post].present?
      @election_view.nomination.post = Post.find_by_id(params[:post])
    end
  end

  def create
    @election_view = ElectionView.new(set_election)
    @election_view.nomination = @election_view.election.nominations.build(nomination_params)
    if @election_view.nomination.save
      redirect_to new_nominations_path, notice: alert_create(Nomination)
    else
      render :new, status: 422
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

  def nomination_params
    params.require(:nomination).permit(:name, :email, :motivation, :post_id)
  end
end
