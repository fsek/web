class Api::AdventureMissionGroupsController < Api::BaseController
  load_permissions_and_authorize_resource

  def index
    @groups = AdventureQueries.highscore_list

    render json: @groups, each_serializer: Api::AdventureMissionGroupSerializer::Index, root: "groups"
  end
end
