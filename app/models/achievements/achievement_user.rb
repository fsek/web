class AchievementUser < ApplicationRecord
  belongs_to :achievement
  belongs_to :user
end
