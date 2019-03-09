class Api::WinesController < Api::BaseController
  load_permissions_and_authorize_resource

  def index
    @wines = Wine.all
    render json: @wines
  end
end
