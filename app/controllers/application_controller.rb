class ApplicationController < ActionController::Base
  include TheRole::Controller
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception  
  
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| 
      u.permit(:password, :password_confirmation, :current_password) 
    }
  end
  
  protect_from_forgery
    def access_denied
    flash[:error] = t('the_role.access_denied')
    redirect_to(:back)
        #Catch exception and redirect to root
    rescue ActionController::RedirectBackError
      redirect_to root_path
  end
  
  before_filter :set_locale
  
  def authenticate_news!
  flash[:error] = t('the_role.access_denied')
    redirect_to(:back) unless current_user.admin? || current_user.moderator?(:nyheter)
    rescue ActionController::RedirectBackError
      redirect_to root_path
  end

  def authenticate_editor_events!
      flash[:error] = t('the_role.access_denied')
    redirect_to(:back) unless current_user.admin? || current_user.has_role?(:event,:edit)
    rescue ActionController::RedirectBackError
      redirect_to root_path
  end
  
    def authenticate_editor_poster!
      flash[:error] = t('the_role.access_denied')
    redirect_to(:back) unless current_user.has_role?(:poster,:edit)
    rescue ActionController::RedirectBackError
      redirect_to root_path
  end
  
  
  
  
  private
  
  def set_locale
    locale = 'sv'
    langs  = %w{ sv en ru es pl zh_CN }

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
  
    protected
        before_filter :session_sanitized_params, if: :devise_controller?
      def session_sanitized_params
      devise_parameter_sanitizer.for(:sign_in) {|u| u.permit(:username, :password, :remember_me)}
    end
    
    before_filter :update_sanitized_params, if: :devise_controller?    
    def update_sanitized_params
      devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:username, :email, :password, :password_confirmation)}
    end
  end