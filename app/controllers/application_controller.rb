# encoding:UTF-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :configure_permitted_devise_parameters, if: :devise_controller?
  before_action :set_locale

  helper_method :alert_update, :alert_create, :alert_destroy

  rescue_from CanCan::AccessDenied do |ex|
    if current_user.nil?
      redirect_to :new_user_session, alert: ex.message
    else
      redirect_to :root, alert: ex.message
    end
  end

  rescue_from ActiveRecord::RecordInvalid do |ex|
    flash[:alert] =
      "Fel i formulär:  #{ex.record.errors.full_messages.join '; '}"
    render referring_action, status: :unprocessable_entity
  end

  rescue_from ActiveRecord::RecordNotFound do
    # translate record not found -> HTTP 404
    fail ActionController::RoutingError.new 'not found'
  end

  rescue_from ActionController::RedirectBackError do
    redirect_to :root
  end

  def model_name(model, multiple)
    if model.instance_of?(Class)
      if multiple
        model.model_name.human(count: 2)
      else
        model.model_name.human
      end
    end
  end

  def alert_update(resource)
    %(#{model_name(resource, false)} #{I18n.t(:success_update)}.)
  end

  def alert_create(resource)
    %(#{model_name(resource, false)} #{I18n.t(:success_create)}.)
  end

  def alert_destroy(resource)
    %(#{model_name(resource, false)} #{I18n.t(:success_destroy)}.)
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

  def self.permission
    name.gsub('Controller', '').singularize.split('::').last.constantize.name rescue nil
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  # load the permissions for the current user so that UI can be manipulated
  def load_permissions
    return unless current_user
    @current_permissions = current_user.posts.each do |post|
      post.permissions.map { |i| [i.subject_class, i.action] }
    end
  end

  # Enables authentication and
  def self.load_permissions_and_authorize_resource(*args)
    load_and_authorize_resource(*args)
    before_action(:load_permissions, *args)
  end

  def self.skip_authorization(*args)
    skip_authorization_check(*args)
    skip_before_filter(:load_permissions, *args)
  end

  # To be used with controllers without models as resource
  def self.load_permissions_then_authorize_resource(*args)
    authorize_resource(*args)
    before_action(:load_permissions, *args)
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

  def referring_action
    Rails.application.routes.recognize_path(request.referer)[:action]
  end
end
