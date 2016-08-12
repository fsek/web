class Introduction < ActiveRecord::Base
  acts_as_paranoid
  translates(:title, :description)
  globalize_accessors(locales: [:en, :sv],
                      attributes: [:title, :description])

  attr_reader :dates, :events_by_day, :dates_by_week

  has_many :groups, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :adventures, dependent: :destroy
  has_many :adventure_groups, through: :adventures

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

  def events(locale: 'sv')
    locale = locale.to_s
    if locale == 'sv'
      get_events
    elsif locale == 'en'
      translation = Event::Translation.where(locale: 'en').where.not(title: nil)
      get_events.joins(:translations).merge(translation)
    else
      Event.none
    end
  end

  def events_by_day(locale: 'sv')
    @events_by_day ||= events(locale: locale.to_s).group_by(&:day)
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
      date - start.to_date.cweek
    elsif date.respond_to?(:to_date)
      date.to_date.cweek - start.to_date.cweek
    end
  end

  private

  def get_events
    Event.slug(:nollning).translations.between(start, stop).by_start
  end
end
