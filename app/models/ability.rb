class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Abilities that everyone get.
    can [:index, :show], Tool
    can :read, [Council, Election, News, WorkPost]
    can :read, Document, public: true
    can [:mail, :read], Contact, public: true
    can [:modal, :show], Post
    can [:new, :create, :read], Faq
    can [:index, :feed], CafeShift
    can [:index, :competition], :cafe
    cannot :ladybug, :cafe
    can :index, Rent
    cannot [:create, :destroy, :update], Rent
    can :show, Page, public: true, visible: true
    can :avatar, User
    can :read, BlogPost

    can :show, Event
    can [:index, :export, :introduction], :calendar
    # But cannot view any albums
    can :index, :gallery
    can [:read, :archive, :matrix, :modal, :dance], Introduction
    can [:index, :about,
         :cookies_information, :company_about,
         :company_offer, :robots], :static_pages
    can [:read, :archive], Adventure

    # Abilities all signed in users get
    if user.id.present?
      can [:edit, :show, :update, :update_password, :update_account], User, id: user.id
      can [:create, :update, :destroy], CafeWorker, user_id: user.id
      can [:show], CafeShift
      can [:create, :destroy], EventUser, user_id: user.id
      can :show, User

      can [:read, :mail], Contact
      can :read, Document, public: true

      can :index, Group
      can :show, Group, users: { id: user.id }

      can([:index, :show], Message, Message.for_user(user)) do |message|
        message.with_group(user)
      end

      can([:create, :destroy], Message, user_id: user.id)

      can(:destroy, MessageComment, MessageComment.by_user(user)) do |comment|
        comment.with_group(user)
      end

      can(:create, MessageComment) do |comment|
        comment.with_group(user) && comment.user == user
      end
      
      can :read, Meeting

      can [:read, :search], Song

      can([:index, :look, :look_all], Notification, user_id: user.id)
    end

    # Only for members of the Guild
    if user.member?
      can [:show], Album

      can [:show, :overview, :new, :create], Rent
      can [:edit, :update, :destroy], Rent, user_id: user.id
      can [:read, :mail], Contact
      can :read, Document

      can [:create, :index, :new], Candidate
      can [:destroy], Candidate, user_id: user.id
      can [:create], Nomination
      can :show, Page, visible: true
      can [:edit, :update], Group, group_users: { fadder: true, user: user }
      can [:create, :destroy], Meeting, user_id: user.id
      can([:edit, :update], Meeting, user_id: user.id, by_admin: false,
                                     status: Meeting.statuses[:unconfirmed])
    end
  end
end
