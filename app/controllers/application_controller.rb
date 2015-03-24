# encoding:UTF-8
class ApplicationController < ActionController::Base
  include TheRole::Controller
  protect_from_forgery

  before_action :configure_permitted_devise_parameters, if: :devise_controller?
  before_action :set_locale
  after_action :menues

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
    devise_parameter_sanitizer.for(:sign_in) do |u|
      u.permit(:username, :password, :remember_me)
    end
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:username, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:password, :password_confirmation, :current_password)
    end
  end

  def set_locale
    locale = 'sv'
    langs = %w{ sv en }

    if params[:locale]
      lang = params[:locale]
      if langs.include? lang
        locale = lang
        cookies[:locale] = lang
      end
    else
      if cookies[:locale]
        lang = cookies[:locale]
        locale = lang if langs.include? lang
      end
    end
    I18n.locale = locale
    redirect_to(:back) if params[:locale]
  end

  def menues
    menu = Menu.where(visible: true)
    @menu_sektionen = menu.where(location: 'Sektionen')
    @menu_medlemmar = menu.where(location: 'För medlemmar')
    @menu_foretag = menu.where(location: 'För företag')
    @menu_kontakt = menu.where(location: 'Kontakt')
  end

  def verify_admin
    access_denied unless (current_user) && (current_user.admin?)
  end
end
