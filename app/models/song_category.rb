class SongCategory < ApplicationRecord
  has_many :songs

  def to_s
    name
  end

  validates :name, presence: true
end
