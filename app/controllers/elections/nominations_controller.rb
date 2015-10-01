# encoding: UTF-8
class Elections::NominationsController < ApplicationController
  before_action :set_election
  load_permissions_and_authorize_resource

  def new
    @nomination = @election.nominations.new
    if params[:post].present?
      @nomination.post == Post.find_by_id(params[:post])
    end
  end

  def create
    @nomination = @election.nominations.build(nomination_params)
    if @nomination.save
      redirect_to new_nominations_path, notice: alert_create(Nomination)
    else
      render :new
    end
  end

  private

  def set_election
    @election = Election.current
    if @election.nil?
      redirect_to elections_path
    end
  end

  def nomination_params
    params.require(:nomination).permit(:name, :email, :motivation, :post_id)
  end
end
