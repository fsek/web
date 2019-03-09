class Wine < ApplicationRecord
  belongs_to :grape

  validates :name, :year, :name, :alcohol, presence: true
  validates :year, numericality: { greater_or_equal_to: 0 }

  def to_s
    "Vinet heter #{name} och är från #{year}"
  end
end
