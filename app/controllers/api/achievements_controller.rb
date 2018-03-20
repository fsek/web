class Api::AchievementsController < Api::BaseController
  load_permissions_and_authorize_resource

  def index
    @achievement_users = current_user.achievement_users
    render json: @achievement_users
  end
end