class AdventureMissionGroup < ApplicationRecord
  belongs_to :adventure_mission
  belongs_to :group

  before_destroy :not_locked

  validate :point_validity, :not_locked
  validates :require_acceptance, null: false

  attr_accessor :require_acceptance

  scope :by_group, ->(group) { where(group: group) }

  def point_validity
    unless points.present? && points > 0 && points <= adventure_mission.max_points
      errors.add(:points, I18n.t('model.adventure_mission_group.invalid_points', max_points: adventure_mission.max_points))
      throw :abort
    end
  end

  def not_locked
    if adventure_mission.locked?
      errors.add(:locked, I18n.t('model.adventure_mission_group.locked'))
      throw :abort
    end
  end
end
