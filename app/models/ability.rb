class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Abilities that everyone get.
    can :read, News

    # The mythical root access
    if user.is? :admin
      can :manage, :all
    end
  end
end
