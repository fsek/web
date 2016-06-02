# encoding:UTF-8
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_devise_parameters, if: :devise_controller?
  before_action :set_locale

  helper_method :alert_update, :alert_create, :alert_destroy,
                :can_administrate?, :authorize_admin!

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

  def model_name(model)
    if model.instance_of?(Class)
      model.model_name.human
    end
  end

  def alert_update(resource)
    %(#{model_name(resource)} #{I18n.t('global_controller.success_update')}.)
  end

  def alert_create(resource)
    %(#{model_name(resource)} #{I18n.t('global_controller.success_create')}.)
  end

  def alert_destroy(resource)
    %(#{model_name(resource)} #{I18n.t('global_controller.success_destroy')}.)
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

  def self.permission
    name.gsub('Controller', '').singularize.split('::').last.constantize.name rescue nil
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  def current_admin_ability
    @current_admin_ability ||= AdminAbility.new(current_user)
  end

  def can_administrate?(*args)
    current_admin_ability.can?(*args)
  end

  def authorize_admin!(*args)
    @_authorized = true
    current_admin_ability.authorize!(*args)
  end

  # load the permissions for the current user so that UI can be manipulated
  def load_permissions
    return unless current_user
    @current_permissions = current_user.permissions.map do |i|
      [i.subject_class, i.action]
    end
  end

  # Enables authentication and
  def self.load_permissions_and_authorize_resource(*args)
    load_and_authorize_resource(*args)
    before_action(:load_permissions, *args)
  end

  # To be used with controllers without models as resource
  def self.load_permissions_then_authorize_resource(*args)
    authorize_resource(*args)
    before_action(:load_permissions, *args)
  end

  def self.skip_authorization(*args)
    skip_authorization_check(*args)
    skip_before_filter(:load_permissions, *args)
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    Rails.application.routes.default_url_options[:locale] = I18n.locale
  end

  def referring_action
    Rails.application.routes.recognize_path(request.referer)[:action]
  end
end
