class Event < ActiveRecord::Base
  acts_as_paranoid
  include CarrierWave::Compatibility::Paperclip
  include Categorizable

  TZID = 'Europe/Stockholm'.freeze
  SINGLE = 'single'.freeze
  DOUBLE = 'double'.freeze
  WITHOUT = 'without'.freeze

  translates(:title, :description, :short, :location)
  globalize_accessors(locales: [:en, :sv],
                      attributes: [:title, :description, :short, :location])
  mount_uploader :image, AttachedImageUploader, mount_on: :image_file_name

  has_one :event_signup, dependent: :destroy
  has_many :event_users, dependent: :destroy
  has_many :users, through: :event_users
  belongs_to :council

  validates(:title, :description, :starts_at, :ends_at, :location,
            presence: true)

  scope :view, -> { select(:starts_at, :ends_at, :all_day, :title, :short, :updated_at) }
  scope :by_start, -> { order(starts_at: :asc) }
  scope :calendar, -> { all }
  scope :translations, -> { includes(:translations) }
  scope :from_date, -> (date) { between(date.beginning_of_day, date.end_of_day) }
  scope :after_date, -> (date) { where('starts_at > :date', date: date || 2.weeks.ago) }
  scope :between, -> (start, stop) do
    where('(starts_at BETWEEN ? AND ?) OR (all_day IS TRUE AND ends_at BETWEEN ? AND ?)',
          start, stop, start, stop)
  end
  scope :stream, -> do
    between(Time.zone.now.beginning_of_day, 6.days.from_now.end_of_day).by_start
  end

  scope :by_locale, ->(locale: I18n.locale) do
    locale = locale.to_s
    if locale == 'sv'
      includes(:translations).all
    elsif locale == 'en'
      translation = Translation.where(locale: 'en').where.not(title: [nil, ''])
      includes(:translations).joins(:translations).merge(translation)
    else
      none
    end
  end

  def self.locations_sv
    Translation.where(locale: 'sv').select(:location).order(:location).uniq.pluck(:location)
  end

  def self.locations_en
    Translation.where(locale: 'en').select(:location).order(:location).uniq.pluck(:location)
  end

  def signup
    event_signup
  end

  def to_s
    title
  end

  # To group event-stream.
  def day
    starts_at.to_date
  end

  def short_title
    short.blank? ? title : short
  end

  def large
    if image.present?
      image.large.url
    end
  end

  def thumb
    if image.present?
      image.thumb.url
    end
  end

  def as_json(*)
    CalendarJSON.event(self)
  end
end
