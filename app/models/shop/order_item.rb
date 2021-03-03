class OrderItem < ApplicationRecord
	validates :amount, numericality: { greater_than_or_equal_to: 0 }
	validates :size, presence: true
	validates :color, presence: true

	has_one :shop_item
	belongs_to :order
end