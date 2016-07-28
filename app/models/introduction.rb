class Introduction < ActiveRecord::Base
  acts_as_paranoid
  translates(:title, :description)
  globalize_accessors(locales: [:en, :sv],
                      attributes: [:title, :description])

  attr_reader :dates, :events_by_day

  has_many :groups, dependent: :destroy
  has_many :messages, dependent: :destroy

  validates :title, :start, :stop, :slug, presence: true
  validates :slug, uniqueness: true,
                   presence: true,
                   format: { with: /\A[a-z0-9-]+\z/ }
  validates :current, uniqueness: true, if: :current

  scope :all_except, -> (introduction) { order(start: :desc).where.not(id: introduction) }
  scope :by_start, -> { order(start: :desc) }

  def self.current
    Introduction.where(current: true).first
  end

  def events
    Event.slug(:nollning).includes(:translations).between(start, stop).by_start
  end

  def events_by_day
    @events_by_day ||= events.group_by(&:day)
  end

  def dates
    @dates ||= start.to_date..stop.to_date
  end

  def to_param
    slug
  end

  def year
    start.year
  end

  def to_s
    title + ' ' + year.to_s
  end

  def week(date)
    date.to_date.cweek - start.to_date.cweek if date.present?
  end
end
