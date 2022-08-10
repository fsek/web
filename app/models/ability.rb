class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Abilities that everyone get.
    can :read, [Council, Election, News, WorkPost]
    can :read, Document, public: true
    can [:mail, :read], Contact, public: true
    can [:modal, :show], Post
    can [:new, :create, :read], Faq
    cannot :ladybug, :cafe
    can :show, Page, public: true, visible: true
    can :avatar, User
    can :confirm_donation, User
    can :unconfirm_donation, User
    can :read, BlogPost

    # can :read, Event
    can [:index, :export, :introduction], :calendar
    # But cannot view any albums
    can :index, :gallery
    can [:read, :archive, :matrix, :modal, :dance], Introduction
    can [:index, :about, :privacy,
         :cookies_information, :company_about,
         :company_offer, :robots, :influence], :static_pages

    # Abilities all signed in users get
    if user.id.present?
      can [:edit, :show, :update, :update_password, :update_account, :accept_terms], User, id: user.id
      can [:index, :feed, :show], CafeShift
      can [:index, :competition], :cafe
      can [:create, :update, :destroy], CafeWorker, user_id: user.id
      can [:create, :destroy], EventUser, user_id: user.id
      can :show, User
      can :index, Rent
      can [:index, :show], Tool

      can :read, Event

      can [:read, :mail], Contact
      # The api needs this symbol syntax (see comment in Api::ContactsController)
      can [:read, :mail], :contact

      can :read, Document, public: true

      can :index, Group
      can :show, Group, users: { id: user.id }

      can([:index, :show, :download_image], Message, Message.for_user(user)) do |message|
        message.with_group(user)
      end

      can([:create, :destroy, :edit, :update, :new_token], Message, user_id: user.id)

      can :read, Meeting
      can [:read, :search, :chants], Song
      can [:index, :visit, :look, :look_all], Notification, user_id: user.id
      can [:create, :destroy], PushDevice
      can :index, :start
      can [:read, :scroll, :matrix], :api_event
      can [:create, :destroy, :toggle], Fredmansky
    end

    # Only for members of the Guild
    if user.member?
      can [:show], Album

      can [:show, :overview, :new, :create], Rent

      if user.car_ban.present?
        cannot(:create, Rent, council_id: nil)
        can(:new, Rent, council_id: nil)
      end

      can [:edit, :update, :destroy], Rent, user_id: user.id
      can [:read, :mail], Contact
      can :read, Document

      can [:create, :index, :new], Candidate
      can :bloodfeud, User
      can [:destroy], Candidate, user_id: user.id
      can [:create], Nomination
      can :show, Page, visible: true
      can [:create, :destroy], Meeting, user_id: user.id
      can([:edit, :update], Meeting, user_id: user.id, by_admin: false,
                                     status: Meeting.statuses[:unconfirmed])
      if Adventure.can_show?(user)
        can [:read, :archive], Adventure
        if user.mentor?
          can [:finish_adventure_mission, :reset_adventure_mission], AdventureMission
          can [:new, :create, :destroy, :edit, :update], AdventureMissionGroup
        end
        can [:show], AdventureMission

      end
      can :index, AdventureMissionGroup
      can :highscore, Adventure
    end
  end
end
