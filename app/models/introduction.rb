# Introduction for new students and members of the guild
class Introduction < ApplicationRecord
  acts_as_paranoid
  translates(:title, :description)
  globalize_accessors(locales: [:en, :sv],
                      attributes: [:title, :description])

  attr_reader :dates, :events_by_day, :dates_by_week

  has_many :groups, dependent: :destroy
  has_many :group_users, through: :groups
  has_many :users, through: :groups
  has_many :messages, dependent: :destroy
  has_many :adventures, dependent: :destroy
  has_many :adventure_groups, through: :adventures

  validates :title, :start, :stop, :slug, presence: true
  validates :slug, uniqueness: true,
                   presence: true,
                   format: { with: /\A[a-z0-9-]+\z/ }
  validates :current, uniqueness: true, if: :current

  scope :all_except, (lambda do |introduction|
    order(start: :desc).where.not(id: introduction)
  end)
  scope :by_start, -> { order(start: :desc) }

  def self.current
    Introduction.where(current: true).first
  end

  def events(locale: 'sv')
    Event.slug(:nollning)
         .by_locale(locale: locale)
         .between(start, stop)
         .by_start
  end

  def events_by_day(locale: 'sv')
    @events_by_day ||= events(locale: locale).group_by(&:day)
  end

  def dates
    @dates ||= start.to_date..stop.to_date
  end

  def dates_by_week
    @dates_by_week ||= dates.group_by(&:cweek)
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
    if date.is_a?(Integer)
      print_week(date)
    elsif date.respond_to?(:to_date)
      print_week(date.to_date.cweek) if date.year == Time.current.year
    end
  end

  private

  def print_week(current)
    current - start.to_date.cweek
  end
end
