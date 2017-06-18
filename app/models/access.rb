class Access < ApplicationRecord
  belongs_to :door
  belongs_to :post

  validates(:door, :post, presence: true)
  validates(:door, uniqueness: { scope: :post })
end
