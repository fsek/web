class Fruit < ApplicationRecord
  belongs_to :user, required: true
  validates :name, presence: true
  validates_inclusion_of :isMoldy, in: [true, false]

  def to_s
    name
  end
end