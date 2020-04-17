class Song < ApplicationRecord
  belongs_to :song_category, optional: false
  has_many :favorite_songs
  validates :title, :content, presence: true

  def to_s
    title
  end

  def self.title_search(title)
    if title.present?
      Song.where('title ILIKE ?', "%#{title}%").limit(10)
    end
  end

  scope :by_visits, -> { order(visits: :desc).limit(10) }
end
