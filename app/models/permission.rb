class Permission < ActiveRecord::Base
  has_many :posts, through: 'permission_post'
  has_many :permission_posts
  validates_presence_of :subject_class, :action
end
