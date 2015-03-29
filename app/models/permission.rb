class Permission < ActiveRecord::Base
  has_many :posts, through: 'permission_post'
  has_many :permission_posts
  validates :subject_class, :action, presence: true
end
