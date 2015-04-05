# encoding: UTF-8
class Post < ActiveRecord::Base
  # Associations
  belongs_to :council
  has_and_belongs_to_many :profiles
  has_many :nominations
  has_many :candidates
  has_many :permission_posts
  has_many :permissions, through: :permission_posts

  # Scopes
  scope :studierad, -> { where(elected_by: "Studierådet").order(council_id: :asc) }
  scope :termins, -> { where(elected_by: "Terminsmötet").order(council_id: :asc) }

  scope :not_termins, -> { where.not(elected_by: "Terminsmötet").order(council_id: :asc) }

  # Validations
  validates :limit, :recLimit, :description, presence: true

  # Scopes
  scope :renters, -> { where(car_rent: true) }

  def printLimit
    if recLimit == 0 && limit == 0 || recLimit > limit
      "*"
    elsif recLimit == limit && recLimit > 0
      %(#{limit}  (x))
    elsif limit > 0 && recLimit == 0
      limit
    elsif limit > recLimit
      %(#{recLimit}- #{limit})
    end
  end

  def limited?
    limit > 0 && profiles.count >= limit
  end

  def add_profile(profile)
    if profile.nil?
      errors.add(profile, I18n.t('errors.messages.not_found'))
      return false
    end

    if profiles.include(profile)
      errors.add(profile, I18n.t('posts.already_have_post'))
      return false
    end

    if limited?
      errors.add(:limit, I18n.t('posts.limited'))
      return false
    end

    profiles << profile
    return true
  end

  def remove_profile(profile)
    profiles.delete(profile)
  end

  def set_permissions(permissions)
    permissions.each do |id|
      #find the main permission assigned from the UI
      permission = Permission.find(id)
      self.permissions << permission
    end
  end
end
