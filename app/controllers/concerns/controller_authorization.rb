# Module for controller authorzation methods
module ControllerAuthorization
  def permission
    name.gsub('Controller', '').singularize.split('::').last.constantize.name rescue nil
  end

  # Enables authentication and
  def load_permissions_and_authorize_resource(*args)
    load_and_authorize_resource(*args)
    before_action(:load_permissions, *args)
  end

  # To be used with controllers without models as resource
  def load_permissions_then_authorize_resource(*args)
    authorize_resource(*args)
    before_action(:load_permissions, *args)
  end

  def skip_authorization(*args)
    skip_authorization_check(*args)
    skip_before_action(:load_permissions, *args, raise: false)
  end
end
