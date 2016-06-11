# encoding:UTF-8
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_devise_parameters, if: :devise_controller?
  before_action :set_locale

  helper_method :alert_update, :alert_create, :alert_destroy,
                :can_administrate?, :authorize_admin!

  include Alerts
  include InstanceAuthorization
  extend ControllerAuthorization

  rescue_from CanCan::AccessDenied do |ex|
    if current_user.nil?
      redirect_to :new_user_session, alert: ex.message
    else
      redirect_to :root, alert: ex.message
    end
  end

  rescue_from ActiveRecord::RecordInvalid do |ex|
    flash[:alert] = ex.record.errors.full_messages.join '; '
    render referring_action, status: :unprocessable_entity
  end

  rescue_from ActiveRecord::RecordNotFound do
    # translate record not found -> HTTP 404
    fail ActionController::RoutingError.new 'not found'
  end

  rescue_from ActionController::RedirectBackError do
    redirect_to :root
  end

  protected

  def configure_permitted_devise_parameters
    devise_parameter_sanitizer.permit(:sign_in) do |u|
      u.permit(:email, :password, :remember_me)
    end
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:firstname, :lastname, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:password, :password_confirmation, :current_password)
    end
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    Rails.application.routes.default_url_options[:locale] = I18n.locale
  end

  def referring_action
    Rails.application.routes.recognize_path(request.referer)[:action]
  end

  def recache_menu
    I18n.available_locales.each do |loc|
      expire_fragment("main_menu/#{loc}")
    end
  end
end
