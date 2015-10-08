class Admin::UsersController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :authorize

  def index
  end

  def member
    @success = UserService.make_member(@user)
    render
  end

  def unmember
    @destroyed = UserService.unmember(@user)
    render
  end

  private

  def authorize
    authorize! :manage, User
  end
end
