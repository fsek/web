class CafeWorker < ActiveRecord::Base
  belongs_to :user
  belongs_to :cafe_shift, inverse_of: :cafe_worker

  has_many :groups, through: :worker_group
  has_many :worker_groups

  def owner?(owner)
    user == owner
  end

  protected

  def user_attributes?
    if !user.has_attributes?
      errors.add(:user, I18n.t('user.attributes_missing'))
      false
    else
      true
    end
  end
end
