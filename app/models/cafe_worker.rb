class CafeWorker < ActiveRecord::Base
  belongs_to :user
  belongs_to :cafe_shift, inverse_of: :cafe_worker

  validates :user_id, :cafe_shift_id, presence: true
  validate :user_attributes?

  def owner?(owner)
    user == owner
  end

  protected

  def user_attributes?
    if !user.try(:has_attributes?)
      errors.add(:user, I18n.t('user.attributes_missing'))
      false
    else
      true
    end
  end
end
