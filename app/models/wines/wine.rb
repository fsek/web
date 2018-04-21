class Wine < ApplicationRecord
  belongs_to :grape

  validates :name, :country, presence: true
  validates :year, inclusion: 1900..2018

  scope :for_index, -> (y) { order(:name).where(year: y) }

  def to_s
    name
  end
end
