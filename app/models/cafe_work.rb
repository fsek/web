# encoding: UTF-8
class CafeWork < ActiveRecord::Base
  # Associations
  belongs_to :user
  has_many :councils, through: :cafe_work_councils
  has_many :cafe_work_councils

  # Validations
  validates :work_day, :pass, :lp, :lv, presence: true
  validates :pass, :lp, inclusion: { in: 1..4 }
  validates :lv, inclusion: { in: 1..20 }
  validates :pass, uniqueness: { scope: [:work_day, :lv, :lp, :d_year] }

  # Scopes
  scope :with_worker, -> { where.not(user: nil) }
  scope :between, ->(from, to) { where(work_day: from..to) }
  scope :ascending, -> { order(pass: :asc) }
  scope :week, ->(week) { where(lv: week) }
  scope :period, ->(p) { where(lp: p) }
  scope :all_work_day, -> { order(work_day: :asc) }

end
