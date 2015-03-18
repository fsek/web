# encoding:UTF-8
class ApplicationController < ActionController::Base
  include TheRole::Controller
  protect_from_forgery

  before_filter :configure_permitted_devise_parameters, if: :devise_controller?
  before_filter :set_locale

  before_filter :get_commit


  def access_denied
    flash[:error] = t('the_role.access_denied')
    redirect_to(:back)
  end

  rescue_from ActionController::RedirectBackError do
    redirect_to root_path
  end 

  rescue_from ActiveRecord::RecordNotFound do
    # translate record not found -> HTTP 404
    fail ActionController::RoutingError.new 'not found'
  end

  protected

  def configure_permitted_devise_parameters
    devise_parameter_sanitizer.for(:sign_in) {|u| u.permit(:username, :password, :remember_me)}
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:username, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:password, :password_confirmation, :current_password) }
  end

  def set_locale
    locale = 'sv'
    langs  = %w{ sv en }

    if params[:locale]
      lang = params[:locale]
      if langs.include? lang
        locale           = lang
        cookies[:locale] = lang
      end
    else
      if cookies[:locale]
        lang   = cookies[:locale]
        locale = lang if langs.include? lang
      end
    end

    I18n.locale = locale
    redirect_to(:back) if params[:locale]
  end

  def get_commit
    if user_signed_in? && current_user && current_user.admin?
      @commit = `git rev-parse HEAD`[0, 6]
      @commit_url = "https://github.com/fsek/web/commit/%s" % @commit
    end
  end

  def verify_admin
    flash[:error] = t('the_role.access_denied')
    redirect_to(:root) unless (current_user) && (current_user.admin?)
  end
end
