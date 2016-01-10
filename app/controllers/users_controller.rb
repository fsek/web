# encoding:UTF-8
class UsersController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :set_user

  def index
  end

  def show
  end

  def avatar
    if @user.avatar?
      style = [:original, :medium, :thumb].include?(params[:style]) ? params[:style] : :medium
      send_file(@user.avatar.path(style), filename: @user.avatar_file_name,
                type: 'image/jpg',
                disposition: 'inline',
                x_sendfile: true)
    end
  end

  def edit
    if @tab.nil?
      if params[:tab].present?
        @tab = params[:tab]
      else
        @tab = :profile
      end
    end
  end

  def update
    @tab = :profile
    if @user.update(user_params)
      flash[:notice] = alert_update(User)
      render :edit
    else
      render :edit, status: 422
    end
  end

  def update_account
    @tab = :account
    if @user.update_with_password(account_params)
      flash[:notice] = t('user.account_updated')
      render :edit
    else
      flash[:alert] = t('user.password_required')
      render :edit, status: 422
    end
  end

  def update_password
    @tab = :password
    if @user.update_with_password(password_params)
      flash[:notice] = t('user.password_updated')
      sign_in @user, bypass: true
      render :edit
    else
      flash[:alert] = t('user.password_required_update')
      render :edit, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:firstname, :lastname, :program, :start_year,
                                 :avatar, :first_post_id, :stil_id, :phone,
                                 :remove_avatar)
  end

  def account_params
    params.require(:user).permit(:email, :current_password)
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
