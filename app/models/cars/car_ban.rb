class CarBan < ApplicationRecord
  belongs_to :user
  belongs_to :creator, class_name: 'User', foreign_key: :creator_id

  validates :user, uniqueness: true
  validates :reason, presence: true
end
