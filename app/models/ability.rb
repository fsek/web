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

    can :read, CafeWork
    can :main, Rent

    # Abilities all signed in users get
    if user.id
      can [:main, :new, :edit, :create, :update, :destroy] , Rent, user_id: user.id
      can [:edit, :update, :show, :update_password, :update_account], User, id: user.id
      #TODO Implement add_worker
      # can :add_worker, CafeWork, user_id: nil
      # can :update_worker, CafeWork, user_id: user.id
      can :update_worker, CafeWork
      can :remove_worker, CafeWork, user_id: user.id
      can [:show, :avatar], User
      can [:read, :display, :hide], Post
    end

    # Only for members of the Guild
    if user.member?
      can :read, Document
      can :read, :old_gallery
      # TODO We really need to move calendar to its own controller
      can [:read, :calendar], Event
      can :manage, Candidate, user_id: user.id
      can :manage, Nomination
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
