class CafeWorker < ActiveRecord::Base
  belongs_to :user
  belongs_to :cafe_shift, inverse_of: :cafe_worker

  validates :user_id, :cafe_shift_id, presence: true
  validate :user_attributes?

  scope :shift_lp_year, -> (lp, year) do
    joins(:cafe_shift).where(cafe_shifts: { lp: lp }).
      where('cafe_shifts.start > ?', year.beginning_of_year).
      where('cafe_shifts.start < ?', year_or_today(year))
  end

  def owner?(owner)
    user == owner
  end

  def lp
    cafe_shift.lp
  end

  protected

  def self.year_or_today(year)
    if year.year == Time.zone.now.year
      Time.zone.now.end_of_day
    else
      year
    end
  end

  def user_attributes?
    if !user.try(:has_attributes?)
      errors.add(:user, I18n.t('user.attributes_missing'))
      false
    else
      true
    end
  end
end
