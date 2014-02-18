class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Require all users to be signed in, at all times.
  # This means that you have to whitelist individual controllers.
  before_filter :authenticate_user!

  # Add extra parameters for registration (devise)
  before_filter :permitted_devise_params, if: :devise_controller?



  protected
    def permitted_devise_params
      # append username
      devise_parameter_sanitizer.for(:sign_up) << :username << :email
      devise_parameter_sanitizer.for(:sign_in) << :username << :email << :login 
      devise_parameter_sanitizer.for(:account_update) << :username << :email
    end

end
