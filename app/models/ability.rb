class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Abilities that everyone get.
    can :read, [News, Council, Page, Election]
    can :read, Document, public: true
    can [:display, :image], Notice
    can [:collapse, :display], Post

    # For calendar-subscription
    can :export, Event

    # TODO Should be removed when everyone is required to log in.
    # /d.wessman 2015-03-28
    can [:read, :update_worker, :remove_worker, :authorize], CafeWork
    can [:read, :main, :new, :edit, :create, :update, :destroy, :authorize], Rent

    # Abilities all signed in users get
    if user.id
     # can :manage, User, id: user.id
      can [:edit, :update, :show], User, id: user.id
      can [:nominate, :candidate], Election
      can :manage, Candidate, user_id: user.id
      can :manage, Nomination
      can [:show, :avatar], User
      can [:read, :display, :hide], Post
      can :read, Document
      can :read, :old_gallery
      # TODO We really need to move calendar to its own controller
      can [:read, :calendar], Event
    end

    # Note: Root access is given dynamically by having a post with permissions :manage, :all

    # Add abilities gained from posts
    user.posts.each do |post|
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
