class RecurringMeeting < ApplicationRecord
  has_many :meetings, dependent: :destroy

  validates :every, presence: true, numericality: { greater_than_or_equal_to: 1 }

  def occurrences
    meetings.count
  end
end
