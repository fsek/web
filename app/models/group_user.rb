class GroupUser < ApplicationRecord
  acts_as_paranoid

  belongs_to :user, required: true
  belongs_to :group, required: true
  validates :user, uniqueness: { scope: :group }

  scope :novices, -> (introduction: Introduction.current) do
    includes(:group).where(fadder: false, groups: { introduction_id: introduction })
  end

  scope :mentors, -> (introduction: Introduction.current) do
    includes(:group).where(fadder: true, groups: { introduction_id: introduction })
  end

  def to_partial_path
    '/groups/group_user'
  end
end
