class PermissionPost < ActiveRecord::Base
  belongs_to :post
  belongs_to :permission
end
