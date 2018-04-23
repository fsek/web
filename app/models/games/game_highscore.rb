class GameHighscore < ApplicationRecord
  belongs_to :user

  validates :points, inclusion: 1..GameQuestion::LAST_QUESTION
  validates :user, uniqueness: true

  def change_if_higher(new_score)
    if new_score > points
      self.points = new_score
    end
  end
end
