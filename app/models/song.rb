class Song < ApplicationRecord
  belongs_to :SongCategory

  def to_s
    title
  end

  validates :title, :content, :category, presence: true

  def self.title_search(title)
    if title.present?
      Song.where('title ILIKE ?', "%#{title}%").limit(10)
    end
  end

  scope :by_visits, -> { order(visits: :desc).limit(10) }
end
