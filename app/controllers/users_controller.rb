# encoding:UTF-8
class UsersController < ApplicationController
  load_permissions_and_authorize_resource

  def index
  end

  def show
    if params[:id].nil?
      @user = current_user
    end
  end

  def edit
  end

  #def update_password
  # if @user.update_with_password(user_params)
  #   redirect_to :edit_user_registration, notice: 'Användaruppgifter uppdaterades.'
  # else
  #   redirect_to :edit_user_registration, notice: 'Lösenord måste fyllas i för att ändra uppgifter.'
  # end
  #nd

  def update
    if @user.update(user_params)
      flash[:notice] = 'Användare uppdaterades.'
      redirect_to edit_user_path @user
    else
      redirect_to :edit_user_registration
    end
  end

  #def destroy
  #  if @user.update_with_password(user_params)
  #    @user.posts.clear
  #    if @user.destroy
  #      redirect_to root_url, notice: 'Användare togs bort.'
  #    end
  #  else
  #    redirect_to :edit_user_registration,
  #      notice: 'Lösenord måste fyllas i för att radera användare.'
  #  end
  #end

  def remove_post
    @post = Post.find_by_id(params[:post_id])
    @user.posts.delete(@post)
    if @user.posts.count == 0
      @user.update(first_post: nil)
    end
    redirect_to edit_user_path(@user), notice: %(Du har inte längre posten #{@post.title}.)
  end

  # Action to show avatar picture only for authenticated
  def avatar
    if @user.avatar?
      style = [:original, :medium, :thumb].include?(params[:style]) ? params[:style] : :medium
      send_file(@user.avatar.path(style), filename:@user.avatar_file_name,
                                          type: 'image/jpg',
                                          disposition: 'inline',
                                          x_sendfile: true)
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password,
                                 :password_confirmation, :current_password,
                                 :firstname, :lastname, :program, :start_year,
                                 :avatar, :first_post, :stil_id, :email, :phone)
  end
end
