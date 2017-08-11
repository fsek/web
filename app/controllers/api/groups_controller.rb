class Api::GroupsController < Api::BaseController
  load_permissions_and_authorize_resource through: :current_user

  def index
    render json: @groups,
           scope: current_user,
           include: ['messages', 'messages.user', 'group_user']
  end
end
