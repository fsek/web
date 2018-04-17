class AdventureGroup < ApplicationRecord
  acts_as_paranoid

  belongs_to :adventure, required: true, inverse_of: :adventure_groups
  belongs_to :group, required: true
  has_one :introduction, through: :group

  validates :group, uniqueness: { scope: :adventure }
  validates :points, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :group_type, :same_introduction, :max_points

  scope :published_results, -> { where(adventures: { publish_results: true }) }
  scope :total_points, -> { group(:group_id).select('group_id, sum(points) as points') }
  scope :for_index, -> { published_results.total_points.includes(:group).order('points desc') }
  scope :for_show, -> { includes(:group).order('points desc') }
  scope :by_adventure_desc, -> { order('adventures.start_date DESC') }

  private

  def group_type
    unless group.regular?
      errors.add(:groups, t('model.adventure_group.wrong_group_type'))
    end
  end

  def same_introduction
    unless group.introduction == adventure.introduction
      errors.add(:groups, t('model.adventure_group.not_same_introduction'))
    end
  end

  def max_points
    unless points <= adventure.max_points
      errors.add(:points, t('model.adventure_group.too_many_points', max: adventure.max_points))
    end
  end
end
