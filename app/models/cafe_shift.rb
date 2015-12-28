# encoding: UTF-8
class CafeShift < ActiveRecord::Base
  # Associations
  has_one :cafe_worker, inverse_of: :cafe_shift
  has_one :user, through: :cafe_worker

  # Validations
  validates :start, :pass, :lp, :lv, presence: true
  validates :pass, :lp, inclusion: { in: 1..4 }
  validates :lv, inclusion: { in: 1..20 }
  validates :pass, uniqueness: { scope: [:start, :lv, :lp] }

  # Scopes
  scope :all_start, -> { order(start: :asc) }
  scope :with_worker, -> { joins(:cafe_worker).includes(:cafe_worker) }
  scope :without_worker, -> { where('id NOT IN (SELECT cafe_shift_id FROM cafe_workers)') }

  attr_accessor :lv_first, :lv_last

  def to_s
    if user.present?
      %(#{model_name.human} #{pass} - #{user})
    else
      %(#{model_name.human} #{pass})
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
    ((pass == 1) || (pass == 2)) ? 2 : 3
  end
end
