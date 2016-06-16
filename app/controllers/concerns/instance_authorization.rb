# Module for instance authorization methods
module InstanceAuthorization
  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  def load_permissions
    return unless current_user

    @current_permissions = current_user.permissions.map do |i|
      [i.subject_class, i.action]
    end
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
end
