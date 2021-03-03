class Inventory < ApplicationRecord
	validates :stock, numericality: { greater_than_or_equal_to: 0 }
	validates :size, presence: true
	validates :color, presence: true
	
	belongs_to :shop_item

	validates_uniqueness_of :shop_item_id, scope: [:size, :color]
end