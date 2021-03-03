class OrderItem < ApplicationRecord
	validates :amount, numericality: { greater_than_or_equal_to: 0 }
	validate :comment

	belongs_to :order
	has_one :shop_item
end