class AdventureMissionGroup < ApplicationRecord
  belongs_to :adventure_mission
  belongs_to :group

  #validates :points, presence: true, numericality: { greater_than: 0 }

  validate :point_validity

  scope :by_group, ->(group) { where(group: group) }

  def point_validity
    unless points.present? && points > 0 && points <= adventure_mission.max_points
      errors.add(:points, I18n.t('model.adventure_mission_group.invalid_points', max_points: adventure_mission.max_points))
    end
  end
end
