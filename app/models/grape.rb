class Grape < ApplicationRecord
  has_many :wines

  scope :red, -> { where(color: :red) }

  validates :name, :color, presence: true
end
