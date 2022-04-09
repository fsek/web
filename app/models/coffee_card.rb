class CoffeeCard < ApplicationRecord
    belongs_to :user, required: true
    validates :available_coffees, presence: true,  numericality: { greater_than_or_equal_to: 0}
end
