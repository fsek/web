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
    can :read, Document, public: true

    # TODO Should be removed when everyone is required to log in.
    # /d.wessman 2015-03-28
    can [:read, :index, :update_worker, :remove_worker, :authorize], CafeWork
    can [:read, :main], Rent

    # Abilities all signed in users get
    if user.id
      can :nominate, Election
      can :candidate, Election
      can :manage, Candidate, profile_id: user.profile.id
      can :manage, Profile, user_id: user.id
      can :read, Post
      can :read, Document
      can :read, :old_gallery
      can :read, Event

      # TODO We really need to move calendar to its own controller
      can :calendar, Event
    end

    # Note: Root access is given dynamically by having a post with permissions :manage, :all

    # Add abilities gained from posts
    user.profile.posts.each do |post|
      post.permissions.each do |permission|
        if permission.subject_class == 'all'
          can permission.action.to_sym, :all
        else
          can permission.action.to_sym, permission.subject_class.constantize
        end
      end
    end
  end
end
