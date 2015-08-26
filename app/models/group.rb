class Group < ActiveRecord::Base
  has_many :group_users
  has_many :users, through: :group_users

  validates :title, :category, presence: true
end
