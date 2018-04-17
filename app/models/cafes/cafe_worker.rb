class CafeWorker < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :cafe_shift, required: true
  has_many :cafe_worker_councils, dependent: :destroy
  has_many :councils, through: :cafe_worker_councils

  validates :user_id, :cafe_shift_id, presence: true
  validate :user_attributes?, :multiple_shifts?

  private

  def user_attributes?
    if user.present? && (user.email.blank? || user.phone.blank?)
      errors.add(:user, I18n.t('model.user.attributes_missing'))
    end
  end

  def multiple_shifts?
    if user.present? && cafe_shift.present? && !similar_shifts
      errors.add(:user, I18n.t('model.cafe_worker.already_working_same_time'))
    end
  end

  def similar_shifts
    user.cafe_shifts.
      where(start: cafe_shift.start).
      where.not(id: cafe_shift.id).empty?
  end
end
