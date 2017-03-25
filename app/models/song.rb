class Song < ActiveRecord::Base
  def to_s
    title
  end

  def self.title_search(title)
    if title.present?
      Song.where('title LIKE ?', "%#{title}%").limit(20)
    end
  end
end
