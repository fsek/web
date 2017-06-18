class Faq < ApplicationRecord
  validates :question, presence: true

  scope :answered, -> { where.not(answer: nil).where.not(answer: '') }
  scope :category, ->(category) { where(category: category) }

  def self.categories
    where.not(category: nil).
      where.not(category: '').
      order(:category).
      pluck(:category).uniq
  end
end
