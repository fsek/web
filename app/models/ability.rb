class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    # This is soo hacky, hope we get rid of profiles soon
    user.profile ||= Profile.new

    # Abilities that everyone get.
    can :read, News
    can :read, Council
    can :read, Election

    # Note: Root access is given by having a post with permissions :manage, :all

    # Add abilities gained from posts
    user.profile.posts.each do |post|
      post.permissions.each do |permission|
        if permission.subject_class == 'all'
          can permission.action.to_sym, permission.subject_class.to_sym
        else
          can permission.action.to_sym, permission.subject_class.constantize
        end
      end
    end
  end
end
