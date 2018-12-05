class Api::CouncilsController < Api::BaseController
  load_and_authorize_resource

  def index
    @councils = Council.by_title
    render json: @councils, each_serializer: Api::CouncilSerializer::Index
  end
end
