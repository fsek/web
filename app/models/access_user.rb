class AccessUser < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :door, required: true

  validates :purpose, presence: true
end
