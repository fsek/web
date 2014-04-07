# encoding:UTF-8
class UsersController < ApplicationController  
  include TheRole::Controller
  before_filter :login_required  
  before_filter :authenticate_user!
  
  
  before_filter :find_user,      :only   => [:edit, :update]
  before_filter :owner_required, :only   => [:edit, :update]

  
  def change_role
    @user = User.find params[:user_id]
    @role = Role.find params[:role_id]
    @user.update_attribute(:role, @role)
    redirect_to users_path
  end
  
  def index    
  @users = User.find(:all)
  end
     
  def update    
    @user.update_attributes params[:user]
 
    flash[:notice] = 'Användare uppdaterades.'
    redirect_to edit_user_path @user
  end

  private 
  def user_params
    params.require(:user).permit(:username,:email)
  end
  
  def find_user
    @user = User.find params[:id]

    # TheRole: You should define OWNER CHECK OBJECT
    # When editable object was found
    
    @owner_check_object = @user
  end
end