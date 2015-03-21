class PermissionPost < ActiveRecord::Base
  belongs_to :post, :permission
end
