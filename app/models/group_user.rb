class GroupUser < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  validates :group, :user, presence: true
  validates :group, uniqueness: { scope: :user }
end
