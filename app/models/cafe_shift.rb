# encoding: UTF-8
class CafeShift < ActiveRecord::Base
  # Associations
  has_one :cafe_worker, inverse_of: :cafe_shift
  has_one :user, through: :cafe_worker
  has_many :groups, through: :cafe_worker

  # Validations
  validates :work_day, :pass, :lp, :lv, presence: true
  validates :pass, :lp, inclusion: { in: 1..4 }
  validates :lv, inclusion: { in: 1..20 }
  validates :pass, uniqueness: { scope: [:work_day, :lv, :lp] }

  # Scopes
  scope :between, ->(from, to) { where(work_day: from..to) }
  scope :ascending, -> { order(pass: :asc) }
  scope :week, ->(week) { where(lv: week) }
  scope :period, ->(lp) { where(lp: lp) }
  scope :year, ->(year) { where('extract(year from work_day) = ?',  year) }
  scope :all_work_day, -> { order(work_day: :asc) }
  scope :with_worker, -> { where.not(worker_id: nil) }

  attr_accessor :lv_first, :lv_last

  def to_s
    if user.present?
      %(#{model_name.human} #{pass} - #{user})
    else
      %(#{model_name.human} #{pass})
    end
  end

  def as_json(user, *)
    CalendarJSON.cafe(self, user)
  end

  def worker?(user)
    self.user.present? && self.user == user
  end

  def start
    work_day
  end

  def stop
    work_day + duration.hours
  end

  protected

  # Duration of work
  def duration
    ((pass == 1) || (pass == 2)) ? 2 : 3
  end
end
