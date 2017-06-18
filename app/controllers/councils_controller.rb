class CouncilsController < ApplicationController
  load_permissions_and_authorize_resource find_by: :url

  def index
    @councils = Council.by_title
  end

  def show
    @council = Council.includes(posts: [:users, :translations]).find_by_url!(params[:id])
    @councils = Council.by_title
  end
end
