class AdminAbility
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Add abilities gained from positions
    user.positions.includes(:permissions).each do |position|
      position.permissions.each do |permission|
        can(permission.action.to_sym, permission.subject)
      end
    end
  end
end
