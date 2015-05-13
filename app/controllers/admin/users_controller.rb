class Admin::UsersController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :authorize

  def index
  end

  private

  def authorize
    authorize! :manage, User
  end
end
