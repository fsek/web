class AdventureMission < ApplicationRecord
  belongs_to :adventure, required: true
  has_many :adventure_mission_groups, dependent: :restrict_with_error
  has_many :groups, through: :adventure_mission_groups

  translates :title, :description
  globalize_accessors locales: [:en, :sv], attributes: [:title, :description]

  attr_accessor :finished, :points

  validates :title_sv, presence: true
  validates :index, numericality: { greater_than_or_equal: 0 }, presence: true
  validates :max_points, numericality: { greater_than: 0 }, presence: true

  scope :by_group, ->(group) { where(group: group) }

  def finished?(group)
    groups.include?(group)
  end

  def points(group)
    if finished?(group)
      adventure_mission_groups.by_group(group).first.points.to_i
    else
      0
    end
  end
end
