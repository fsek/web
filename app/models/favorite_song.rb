class FavoriteSong < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :song, required: true

  validates_uniqueness_of :user_id, :scope => :song_id
end