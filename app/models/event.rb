# encoding: UTF-8
class Event < ActiveRecord::Base
  include CarrierWave::Compatibility::Paperclip
  TZID = 'Europe/Stockholm'.freeze
  SINGLE = 'single'.freeze
  DOUBLE = 'double'.freeze

  translates(:title, :description, :short)
  globalize_accessors(locales: [:en, :sv],
                      attributes: [:title, :description, :short])

  mount_uploader :image, AttachedImageUploader, mount_on: :image_file_name

  has_many :categorizations, as: :categorizable
  has_many :categories, through: :categorizations
  belongs_to :council
  belongs_to :user

  validates(:title, :description, :starts_at, :ends_at, :location,
            presence: true)

  # Validate only if signup is true
  validates(:last_reg, :slots, presence: true, if: Proc.new { |e| e.signup })

  scope :start, -> { order(starts_at: :asc) }
  scope :calendar, -> { all }
  scope :nollning, -> { where(category: :nollning) }
  scope :from_date, -> (date) { between(date.beginning_of_day, date.end_of_day) }
  scope :between, -> (start, stop) do
    where('(starts_at BETWEEN ? AND ?) OR (all_day IS TRUE AND ends_at BETWEEN ? AND ?)',
          start, stop, start, stop)
  end
  scope :stream, -> do
    between(Time.zone.now.beginning_of_day, 6.days.from_now.end_of_day).start
  end

  def self.locations
    select(:location).order(:location).uniq.pluck(:location)
  end

  def to_s
    title
  end

  # To group event-stream.
  def day
    starts_at.to_date
  end

  def short_title
    short.present? ? short : title
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

  def ical(ical_event)
    IcalService.event(ical_event, self)
  end

  def as_json(*)
    CalendarJSON.event(self)
  end
end
