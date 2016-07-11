class GroupUser < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user, required: true
  belongs_to :group, required: true
  validates :user, uniqueness: { scope: :group }

  def to_partial_path
    '/groups/group_user'
  end
end
