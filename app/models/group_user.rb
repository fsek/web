class GroupUser < ActiveRecord::Base
  belongs_to :user, required: true
  belongs_to :group, required: true

  acts_as_paranoid

  def to_partial_path
    '/groups/group_user'
  end
end
