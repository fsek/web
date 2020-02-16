class Wine < ApplicationRecord
  validates :name, :year, presence: true
  validates :year, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :by_name, -> { order(name: :asc) }

  def to_s
    "Vinet heter #{name} och är från #{year}"
  end
end
