class PermissionPost < ActiveRecord::Base
  belongs_to :post
  belongs_to :permission
  validates_presence_of :post, :permission
end
