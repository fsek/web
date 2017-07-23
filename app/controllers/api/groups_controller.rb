class Api::GroupsController < Api::BaseController
  load_permissions_and_authorize_resource through: :current_user

  def index
    render json: @groups, include: ['messages', 'messages.user']
  end
end
