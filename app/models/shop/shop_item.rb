class ShopItem < ApplicationRecord
	validates :name, presence: true
	validate :description
	validates :price, numericality: { greater_than_or_equal_to: 0 }
	validates :sizes, presence: true
	validates :colors, presence: true

	has_many :order_items, dependent: :destroy
	has_many :cart_items, dependent: :destroy
	has_many :inventory, dependent: :destroy
	has_many :images
	
	mount_uploader :avatar, AttachedImageUploader, mount_on: :avatar_file_name

	before_save :remove_blank_fields 

	def remove_blank_fields
	  sizes.reject!(&:blank?)
	  colors.reject!(&:blank?)
	end

	def to_s
		name
	end
end