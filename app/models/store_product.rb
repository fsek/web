class StoreProduct < ApplicationRecord
  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  scope :in_stock, -> { where(in_stock: true) }

  def to_s
    name
  end
end
