class Fruit < ApplicationRecord
  belongs_to :user, required: true
  validates :name, presence: true
  validates_inclusion_of :is_moldy, in: [true, false]

  def to_s
    name
  end
end