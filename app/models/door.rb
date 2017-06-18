class Door < ApplicationRecord
  validates(:title, :slug, :description, presence: true)
  validates(:slug, uniqueness: true)

  has_many :accesses
  has_many :posts, through: :accesses
  has_many :users, -> { distinct }, through: :posts

  scope :by_title, -> { order(title: :asc) }

  def to_s
    title
  end
end
