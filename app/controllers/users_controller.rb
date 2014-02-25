class UsersController < ApplicationController

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params[:user]
    end
end
