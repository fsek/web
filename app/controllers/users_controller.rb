# encoding:UTF-8
class UsersController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :set_user

  def index
  end

  def show
  end

  def profile
  end

  def edit
    if @tab.nil?
      @tab = :profile
    end
  end

  def update_account
    @tab = :account
    if @user.update_with_password(account_params)
      redirect_to :edit_user, notice: 'Kontoinställningar uppdaterades.', tab: :account
      sign_in @user, bypass: true
    else
      @tab = :account
      render action: :edit, notice: 'Lösenord måste fyllas i för att ändra uppgifter.'
    end
  end

  def update_password
    @tab = :password
    if @user.update_with_password(password_params)
      redirect_to :edit_user, notice: 'Lösenordet uppdaterades.'
      sign_in @user, bypass: true
    else
      render action: :edit, notice: 'Nuvarande lösenord måste fyllas i för att byta lösenord.'
    end
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'Användare uppdaterades.'
    end
    @tab = :profile
    render action: :edit
  end

  # def destroy
  #  if @user.update_with_password(user_params)
  #    @user.posts.clear
  #    if @user.destroy
  #      redirect_to root_url, notice: 'Användare togs bort.'
  #    end
  #  else
  #    redirect_to :edit_user_registration,
  #      notice: 'Lösenord måste fyllas i för att radera användare.'
  #  end
  # end

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
      send_file(@user.avatar.path(style), filename: @user.avatar_file_name,
                                          type: 'image/jpg',
                                          disposition: 'inline',
                                          x_sendfile: true)
    end
  end

  private

  def user_params
    params.require(:user).permit(:firstname, :lastname, :program, :start_year,
                                 :avatar, :first_post_id, :stil_id, :phone,
                                 :remove_avatar)
  end

  def account_params
    params.require(:user).permit(:username, :email, :current_password)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end

  def set_user
    if params[:id].nil?
      @user = current_user
    end
  end
end
