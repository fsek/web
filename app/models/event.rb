class Event < ApplicationRecord
  acts_as_paranoid
  include CarrierWave::Compatibility::Paperclip
  include Categorizable

  TZID = 'Europe/Stockholm'.freeze
  SINGLE = 'single'.freeze
  DOUBLE = 'double'.freeze
  WITHOUT = 'without'.freeze

  translates(:title, :description, :short, :location)
  globalize_accessors(locales: [:en, :sv], attributes: [:title, :description, :short, :location])
  mount_uploader :image, AttachedImageUploader, mount_on: :image_file_name

  has_one :event_signup, dependent: :destroy
  has_many :event_users, inverse_of: :event
  has_many :users, through: :event_users
  belongs_to :council
  belongs_to :contact

  serialize :dress_code, Array

  validates(:title_sv, :title_en, :description_sv, :description_en, :starts_at, :ends_at, :location_sv, presence: true)

  # Schedules notifications if event_signup is created or updated
  # This will lead to multiple notifications being queued if the event or signup
  # is updated multiple times, but the task will only run once.
  after_save(:schedule_notifications)
  after_destroy(:destroy_event_users)

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
    between(Time.zone.now.beginning_of_day, 6.days.from_now.end_of_day).by_start.includes(:event_signup)
  end

  scope :starts_within, (lambda do |time|
    where('starts_at BETWEEN :first AND :second',
          first: Time.zone.now,
          second: time.from_now)
  end)

  scope :not_reminded, -> { joins(:event_signup).merge(EventSignup.reminder_not_sent) }
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
    Translation.where(locale: 'sv').select(:location).order(:location).distinct.pluck(:location)
  end

  def self.locations_en
    Translation.where(locale: 'en').select(:location).order(:location).distinct.pluck(:location)
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

  private

  def schedule_notifications
    NotificationService.event_schedule_notifications(self)
  end

  def destroy_event_users
    # Destroy the notifications first (avoids a lot of N+1 queries)
    NotificationService.destroy_for(self)
    event_users.destroy_all
  end
end
