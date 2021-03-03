class Order < ApplicationRecord
	validates_inclusion_of :paid, in: [true, false]
	validates_inclusion_of :packaged, in: [true, false]

	belongs_to :user
	has_many :order_items, dependent: :destroy
end