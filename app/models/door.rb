class Door < ApplicationRecord
  validates(:title, :slug, :description, presence: true)
  validates(:slug, uniqueness: true)

  has_many :accesses, dependent: :destroy
  has_many :posts, through: :accesses
  has_many :users, -> { distinct }, through: :posts
  has_many :access_users, dependent: :destroy

  scope :by_title, -> { order(title: :asc) }

  def to_s
    title
  end
end
