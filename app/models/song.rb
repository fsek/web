<<<<<<< fc75d560e5430ec3c20a5d40602cbd072212564a
class Song < ActiveRecord::Base
  def to_s
    title
  end

  validates :title, :content, presence: true

  def self.title_search(title)
    if title.present?
      Song.where('title LIKE ?', "%#{title}%").limit(10)
    end
  end

  scope :by_visits, -> { order(visits: :desc).limit(10) }
end
