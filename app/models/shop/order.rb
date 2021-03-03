class Order < ApplicationRecord
	validates_inclusion_of :complete, in: [true, false]

	belongs_to :user
	has_many :order_items, dependent: :destroy
end