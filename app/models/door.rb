class Door < ActiveRecord::Base
  validates(:title, :slug, :description, presence: true)
  validates(:slug, uniqueness: true)

  has_many :accesses
  has_many :positions, through: :accesses
  has_many :users, -> { distinct }, through: :positions

  scope :by_title, -> { order(title: :asc) }

  def to_s
    title
  end
end
