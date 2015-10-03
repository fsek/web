class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Abilities that everyone get.
    can :read, [Council, Election, News, Page]
    can :read, Document, public: true
    can [:mail, :read], Contact, public: true
    can [:display, :image], Notice
    can [:collapse, :display, :show], Post
    can [:create, :read], Faq
    can :read, CafeWork
    cannot [:add_worker, :update_worker, :remove_worker], CafeWork
    can :main, Rent
    cannot [:create, :destroy, :update], Rent

    # For calendar-subscription
    can :export, :calendar

    can [:index, :matrix, :modal], :nollning

    # Abilities all signed in users get
    if user.id.present?
      can [:index, :create], Rent
      can [:show, :update, :destroy], Rent, user_id: user.id
      can [:edit, :show, :update, :update_password, :update_account], User, id: user.id
      can :add_worker, CafeWork, user_id: nil
      can [:edit, :update_worker, :remove_worker], CafeWork, user_id: user.id
      can [:show, :avatar], User
      can [:show, :display, :hide], Post

      # Temporarily letting non-members see the calendar
      can [:read, :mail], Contact
      can :index, :calendar
      can :read, Document
    end

    # Only for members of the Guild
    if user.member?
      # Add album abilities
      can [:read, :mail], Contact
      can :read, Document
      can :read, :old_gallery
      can :index, :calendar
      can :read, Event
      #can [:read, :create, :destroy], EventRegistration

      can [:create, :index], Candidate
      can [:update, :show, :destroy], Candidate, user_id: user.id
      can [:create], Nomination
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
