# encoding:UTF-8
class UsersController < ApplicationController
  include TheRole::Controller
  before_filter :login_required
  before_filter :authenticate_admin!, only: [:index]
  before_filter :find_user, only: [:edit, :update, :destroy, :update_password,:remove_post, :avatar]
  before_filter :owner_required, only: [:edit, :update]

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
    if @user.update_with_password(user_params)
      redirect_to :edit_user_registration, notice: 'Användaruppgifter uppdaterades.'
    else
      redirect_to :edit_user_registration, notice: 'Lösenord måste fyllas i för att ändra uppgifter.'
    end

  end

  def update
    @user.update(user_params)
    flash[:notice] = 'Användare uppdaterades.'
    redirect_to edit_user_path @users
  end

  def destroy
    respond_to do |format|
      if @user.update_with_password(user_params)
        @user.posts.clear
        if @user.destroy

          format.html { redirect_to root_url, notice: 'Användare togs bort..' }
          format.json { head :no_content }
        end
      else
        format.html { redirect_to :edit_user_registration, notice: 'Lösenord måste fyllas i för att radera användare.' }
        format.json { head :no_content }
      end
    end
  end

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
      if(params[:style] == "original" || params[:style] == "medium" || params[:style] == "thumb")
        send_file(@user.avatar.path(params[:style]), filename:@user.avatar_file_name, type: "image/jpg",disposition: 'inline',x_sendfile: true)
      else
        send_file(@user.avatar.path(:medium), filename:@user.avatar_file_name, type: "image/jpg",disposition: 'inline',x_sendfile: true)
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password,
                                 :password_confirmation, :current_password,
                                 :firstname, :lastname, :program, :start_year,
                                 :avatar, :first_post, :stil_id, :email, :phone)
  end

  def authenticate_admin!
    flash[:error] = t('the_role.access_denied')
    redirect_to(:back) unless current_user && current_user.moderator?(:users)
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  def find_user
    @user = User.find(params[:id])

    # TheRole: You should define OWNER CHECK OBJECT
    # When editable object was found

    @owner_check_object = @user
  end

end
