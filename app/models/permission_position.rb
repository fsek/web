class PermissionPosition < ActiveRecord::Base
  belongs_to :position, required: true
  belongs_to :permission, required: true
  validates :position, uniqueness: { scope: :permission }
end
