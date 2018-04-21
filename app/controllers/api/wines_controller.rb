class Api::WinesController < Api::BaseController
  #load_permissions_and_authorize_resource

  def index
    @wines = Wine.for_index(params[:foo])

    render json: @wines, each_serializer: Api::WineSerializer::Index
  end

  def show
    @wine = Wine.find(params[:id])

    render json: @wine, serializer: Api::WineSerializer::Show
  end
end
