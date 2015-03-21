class Permission < ActiveRecord::Base
  has_many :posts, through: 'permission_post'
end
