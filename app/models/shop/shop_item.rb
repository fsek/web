class ShopItem < ApplicationRecord
	validates :name, presence: true
	validate :description
	validates :price, numericality: { greater_than_or_equal_to: 0 }
	validate :image_url

	has_many :order_items, dependent: :destroy

	def to_s
		name
	end
end