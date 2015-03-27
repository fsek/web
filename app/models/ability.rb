class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    # This is soo hacky, hope we get rid of profiles soon
    user.profile ||= Profile.new

    # Abilities that everyone get.
    can :read, News
    can :read, Council
    #
    can :read, Election
    can :read, CafeWork
    # Should be removed when everyone is required to log in.
    can :update_worker, CafeWork
    can :remove_worker, CafeWork

    # Abilities all signed in users get
    if user.id
      can :read, Post
      can :read, Document
      can :read, :old_gallery
      can :read, Event
      # We really need to move calendar to its own controller
      can :calendar, Event
    end

    # Note: Root access is given dynamically by having a post with permissions :manage, :all

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
