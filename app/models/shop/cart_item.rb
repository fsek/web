class CartItem < ApplicationRecord
	validates :amount, numericality: { greater_than_or_equal_to: 0 }
	validates :size, presence: true
	validates :color, presence: true
	
	belongs_to :user
	belongs_to :shop_item
end