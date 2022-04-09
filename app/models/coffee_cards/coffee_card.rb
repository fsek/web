class CoffeeCard < ApplicationRecord
    belongs_to :user, required: true
    validates_numericality_of :available_coffees, :greater_than => -1
end