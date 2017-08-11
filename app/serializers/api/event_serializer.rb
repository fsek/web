class Api::EventSerializer < ActiveModel::Serializer
  attributes(:id, :title, :description, :location, :starts_at, :ends_at, :all_day, :dot,
             :drink, :food, :cash, :price, :dress_code, :can_signup, :event_user_count, :short)

  belongs_to :contact
  has_one :event_signup

  has_one :event_user do
    object.event_users.where(user: scope).first
  end

  has_many :groups do
    scope.groups.merge(object.signup.selectable_groups)
  end

  def event_user_count
    object.event_users.count
  end

  def can_signup
    EventUser.eligible_user?(object, scope)
  end

  def description
    MarkdownHelper.markdown(object.description)
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
    attributes(:id, :group_id, :answer, :user_type, :group_custom)
    attribute(:reserve) { object.reserve? }
  end

  class Api::GroupSerializer < ActiveModel::Serializer
    attributes(:id, :name)
  end
end
