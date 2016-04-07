class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Abilities that everyone get.
    can :read, [Council, Election, News, WorkPost]
    can :read, Document, public: true
    can [:mail, :read], Contact, public: true
    can [:collapse, :display], Post
    can [:new, :create, :read], Faq
    can [:index, :feed], CafeShift
    can [:index, :competition], :cafe
    cannot :ladybug, :cafe
    can :main, Rent
    cannot [:create, :destroy, :update], Rent
    can :show, Page, public: true, visible: true
    can :avatar, User

    can :show, Event
    can [:index, :export], :calendar
    # But cannot view any albums
    can :index, :gallery
    can [:index, :matrix, :modal], :nollning
    can [:index, :about, :cookies_information, :company_about, :company_offer], :static_pages

    # Abilities all signed in users get
    if user.id.present?
      can [:edit, :show, :update, :update_password, :update_account], User, id: user.id
      can [:create, :update, :destroy], CafeWorker, user_id: user.id
      can [:show], CafeShift
      can [:show, :avatar], User

      can [:read, :mail], Contact
      can :read, Document, public: true
    end

    # Only for members of the Guild
    if user.member?
      can [:show], Album
      can [:show, :index, :new, :create], Rent
      can [:edit, :update, :destroy], Rent, user_id: user.id
      can [:read, :mail], Contact
      can :read, Document

      can [:create, :index], Candidate
      can [:update, :show, :destroy], Candidate, user_id: user.id
      can [:create], Nomination
      can :show, Page, visible: true
    end
  end
end
