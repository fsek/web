class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Abilities that everyone get.
    can :read, [Council, Election, News]
    can :read, Document, public: true
    can [:mail, :read], Contact, public: true
    can [:display, :image], Notice
    can [:collapse, :display, :show], Post
    can [:new, :create, :read], Faq
    can :read, CafeWork
    cannot [:add_worker, :update_worker, :remove_worker], CafeWork
    can :main, Rent
    cannot [:create, :destroy, :update], Rent
    can :show, Page

    can :show, Event
    can [:index, :export], :calendar
    # But cannot view any albums
    can :index, :gallery
    can [:index, :matrix, :modal], :nollning

    # Abilities all signed in users get
    if user.id.present?
      can [:edit, :show, :update, :update_password, :update_account], User, id: user.id
      can :add_worker, CafeWork, user_id: nil
      can [:edit, :update_worker, :remove_worker], CafeWork, user_id: user.id
      can [:show, :avatar], User
      can [:show, :display, :hide], Post

      can [:read, :mail], Contact
      can :read, Document
    end

    # Only for members of the Guild
    if user.member?
      # Only members allowed to rent
      can [:index, :new, :create], Rent
      can [:show, :update, :destroy], Rent, user_id: user.id
      can [:show], Album
      can [:read, :mail], Contact
      can :read, Document

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
