class CafeShift < ApplicationRecord
  # Associations
  has_one :cafe_worker
  has_one :user, through: :cafe_worker

  # Validations
  validates :start, :pass, :lp, :lv, presence: true
  validates :lp, inclusion: {in: 1..4}
  validates :pass, inclusion: {in: 1..3}
  validates :lv, inclusion: {in: 0..8}

  # Scopes
  scope :all_start, -> { order(start: :asc) }
  scope :with_worker, -> { joins(:cafe_worker).includes(:cafe_worker) }
  scope :without_worker, -> { where("id NOT IN (SELECT cafe_shift_id FROM cafe_workers)") }

  attr_accessor :lv_first, :lv_last, :setup_mode

  def to_s
    if user.present?
      user.to_s
    else
      I18n.t("model.cafe_shift.is_free").to_s
    end
  end

  def as_json(options = {})
    owner = false
    if options.present?
      owner = (user.try(:id) == options[:user].try(:id))
    end
    CalendarJSON.cafe(self, owner)
  end

  def worker?(user)
    self.user.present? && self.user == user
  end

  def stop
    start + duration.hours
  end

  protected

  # Duration of work
  def duration
    pass
  end
end
