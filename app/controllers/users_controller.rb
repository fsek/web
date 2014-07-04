# encoding:UTF-8
class UsersController < ApplicationController  
  include TheRole::Controller
  before_filter :login_required  
  before_filter :authenticate_user!
  
  before_filter :find_user,      :only   => [:edit, :update,:destroy,:update_password]
  before_filter :owner_required, :only   => [:edit, :update]
  
  def change_role
    @user = User.find params[:user_id]
    @role = Role.find params[:role_id]
    @user.update_attribute(:role, @role)
    redirect_to users_path
  end
  
  def index    
    @users = User.all
  end

  def update_password    
    respond_to do |format|
      if @user.update_with_password(user_params)
        format.html { redirect_to :edit_user_registration, notice: 'Användaruppgifter uppdaterades.'  }
        format.json { head :no_content }
      else
        format.html{ redirect_to :edit_user_registration , notice: 'Lösenord måste fyllas i för att ändra uppgifter.' }      
        format.json { head :no_content }      
      end
    end    
  end   

  def update    
    @user.update(user_params) 
    flash[:notice] = 'Användare uppdaterades.'
    redirect_to edit_user_path @user
  end

  def destroy
    respond_to do |format|
      if @user.update_with_password(user_params)
        @user.profile.posts.clear
        if @user.destroy
          
          format.html { redirect_to root_url, notice: 'Användare togs bort..'  }
          format.json { head :no_content }
        end
      else  
        format.html{ redirect_to :edit_user_registration , notice: 'Lösenord måste fyllas i för att radera användare.' }      
        format.json { head :no_content }      
      end
    end
  end

  private 
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :current_password)
  end
  
  def find_user
    @user = User.find(params[:id])

    # TheRole: You should define OWNER CHECK OBJECT
    # When editable object was found
    
    @owner_check_object = @user
  end
end
