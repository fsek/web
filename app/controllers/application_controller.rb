# encoding:UTF-8
class ApplicationController < ActionController::Base
  include TheRole::Controller
  protect_from_forgery
  
  before_filter :configure_permitted_devise_parameters, if: :devise_controller?
  before_filter :set_locale

  
  def access_denied
    flash[:error] = t('the_role.access_denied')
    redirect_to(:back)
    
    rescue ActionController::RedirectBackError
      redirect_to root_path
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
end
