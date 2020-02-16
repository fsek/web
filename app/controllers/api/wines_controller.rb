class Api::WinesController < Api::BaseController
  load_permissions_and_authorize_resource

  def index
    @wines = Wine.by_name
    render json: @wines, each_serializer: Api::WineSerializer::Index
  end
end
