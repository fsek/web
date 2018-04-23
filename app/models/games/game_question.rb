class GameQuestion < ApplicationRecord
  LAST_QUESTION = 50

  validates :question, :answer1, :answer2, :answer3, :correct, presence: true
  validates :correct, inclusion: 1..3

  def correct?(answer)
    answer == correct
  end

  def last?
    id == LAST_QUESTION
  end
end
