class Grape < ApplicationRecord
  has_many :wines

  validates :name, :color, presence: true

  def to_s
    "#{name} (#{color})"
  end
end
