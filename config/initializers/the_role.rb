# TheRole.config.param_name => value

TheRole.configure do |config|
  config.layout                = :application
  config.default_user_role     = :user
  config.access_denied_method  = :access_denied      # define it in ApplicationController
  config.login_required_method = :authenticate_user! # devise auth method
  config.first_user_should_be_admin = true
end
