class Introduction < ActiveRecord::Base
  has_many :groups, dependent: :destroy

  validates :title, :start, :stop, :slug, presence: true
  validates :slug, uniqueness: true,
                   presence: true,
                   format: { with: /\A[a-z0-9_-]+\z/ }
  validates :current, uniqueness: true, if: :current
  translates(:title, :description)
  globalize_accessors(locales: [:en, :sv],
                      attributes: [:title, :description])

  acts_as_paranoid

  scope :all_except, -> (introduction) { order(start: :desc).where.not(id: introduction) }
  scope :by_start, -> { order(start: :desc) }

  def to_param
    slug
  end

  def self.current
    Introduction.where(current: true).first
  end

  def year
    start.year
  end

  def to_s
    title + ' ' + year.to_s
  end
end
