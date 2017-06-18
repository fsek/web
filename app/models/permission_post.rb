class PermissionPost < ApplicationRecord
  belongs_to :post
  belongs_to :permission
  validates :post, :permission, presence: true
end
