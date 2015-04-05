# encoding:UTF-8
class UsersController < ApplicationController
  load_permissions_and_authorize_resource

  def index
  end

  def update_password
    if @user.update_with_password(user_params)
      redirect_to :edit_user_registration, notice: 'Användaruppgifter uppdaterades.'
    else
      redirect_to :edit_user_registration, notice: 'Lösenord måste fyllas i för att ändra uppgifter.'
    end
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'Användare uppdaterades.'
      redirect_to edit_user_path @user
    else

    end
  end

  def destroy
    if @user.update_with_password(user_params)
      @user.profile.posts.clear
      if @user.destroy
        redirect_to root_url, notice: 'Användare togs bort.'
      end
    else
      redirect_to :edit_user_registration,
                  notice: 'Lösenord måste fyllas i för att radera användare.'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email,
                                 :password, :password_confirmation,
                                 :current_password)
  end
end
