class Api::EventSerializer < ActiveModel::Serializer
  include EventHelper

  attributes(:id, :title, :description, :location, :starts_at, :ends_at, :all_day, :dot, :drink,
             :food, :cash, :price, :dress_code, :can_signup, :event_user_count, :short, :user_types)

  belongs_to :contact
  has_one :event_signup

  has_one :event_user do
    object.event_users.where(user: scope).first
  end

  has_many :groups do
    if object.signup.present?
      scope.groups.merge(object.signup.selectable_groups)
    end
  end

  def user_types
    if object.signup.present? && object.signup.order.any?
      event_user_types(object.signup, scope, include_other: false)
    end
  end

  def event_user_count
    object.event_users.count
  end

  def can_signup
    EventUser.eligible_user?(object, scope)
  end

  def description
    MarkdownHelper.markdown_api(object.description)
  end

  class Api::ContactSerializer < ActiveModel::Serializer
    attributes(:id, :name)
  end

  class Api::EventSignupSerializer < ActiveModel::Serializer
    attributes(:id, :opens, :closes, :slots, :question)
    attribute(:closed) { object.closed? }
    attribute(:open) { object.open? }
  end

  class Api::EventUserSerializer < ActiveModel::Serializer
    include EventHelper

    attributes(:id, :group_id, :answer, :user_type, :group_custom)
    attribute(:reserve) { object.reserve? }

    def user_type
      event_user_type(object.event_signup, object.user_type)
    end
  end

  class Api::GroupSerializer < ActiveModel::Serializer
    attributes(:id, :name)
  end
end
