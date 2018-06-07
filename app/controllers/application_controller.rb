class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: :devise_token_controller
  before_action :configure_permitted_devise_parameters, if: :devise_controller?
  before_action :store_current_location, unless: -> { devise_controller? || !request.format.html? }
  before_action :set_locale
  before_action :prepare_meta_tags, if: -> { request.get? }

  helper_method :alert_update, :alert_create, :alert_destroy,
                :can_administrate?, :authorize_admin!

  include Alerts
  include InstanceAuthorization
  extend ControllerAuthorization

  rescue_from CanCan::AccessDenied do |ex|
    if current_user.nil?
      redirect_to(new_user_session_path, alert: ex.message)
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

  protected

  def prepare_meta_tags(options = {})
    site_name = I18n.t('global.title')
    description = options[:description] || I18n.t('global.description')
    image = options[:image] || view_context.image_url('sektionsmarke.png')
    current_url = request.url

    defaults = {
      site:        site_name,
      image:       image,
      description: description,
      keywords:    I18n.t('global.keywords'),
      twitter: {
        site_name: site_name,
        site: '@fsektionen',
        card: 'summary',
        description: description,
        image: image
      },
      og: {
        url: current_url,
        site_name: site_name,
        image: image,
        description: description,
        type: 'website',
        locale: I18n.locale.to_s
      }
    }

    options.reverse_merge!(defaults)
    set_meta_tags(options)
  end

  def configure_permitted_devise_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password, :remember_me])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname, :lastname, :email,
                                                       :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:password, :current_password,
                                                              :password_confirmation])
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    Rails.application.routes.default_url_options[:locale] = I18n.locale
  end

  def referring_action
    Rails.application.routes.recognize_path(request.referer)[:action]
  end

  # Makes redirect after sign_in work
  def store_current_location
    store_location_for(:user, request.url)
  end

  def recache_menu
    I18n.available_locales.each do |loc|
      expire_fragment("main_menu/#{loc}")
    end
  end

  # Ignore session cookies when we want to sign in with devise token auth!
  def devise_token_controller
    params[:controller].split('/')[0] == 'devise_token_auth'
  end

  # Adds pagination meta data (from kaminari) to a serializer
  # Usage: `render json: @collection, meta: pagination_dict(collection)`
  def pagination_meta(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }
  end
end
