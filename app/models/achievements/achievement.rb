class Achievement < ApplicationRecord
  has_many :achievement_users
  has_many :users, through: :achievement_users

  validates :name, :points, presence: true
  def to_s
    name
  end
end
