class AdventureMission < ApplicationRecord
  belongs_to :adventure, required: true
  has_many :adventure_mission_groups, dependent: :restrict_with_error
  has_many :groups, through: :adventure_mission_groups

  translates :title, :description
  globalize_accessors locales: [:en, :sv], attributes: [:title, :description]

  attr_accessor :finished, :points

  validates :title_sv, presence: true
  validates :index, numericality: {greater_than_or_equal: 0}, presence: true
  validates :max_points, numericality: {greater_than: 0}, presence: true
  validates :require_acceptance, null: false

  scope :by_group, ->(group) { where(group: group) }

  # Mission is regarded finished when a Mentor marked it as such
  # (a corresponding AdventureMissionGroup exists)
  def finished?(group)
    groups.include?(group)
  end

  # Mission is regarded accepted when an admin has accepted it
  # (pending == false in the corresponding AdventureMissionGroup)
  def accepted?(group)
    finished?(group) && adventure_mission_groups.by_group(group).first.pending == false
  end

  def points_per_group(group)
    # Points only rewarded once mission is accepted
    if accepted?(group)
      adventure_mission_groups.by_group(group).first.points.to_i
    else
      0
    end
  end
end
