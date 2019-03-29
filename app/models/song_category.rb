class SongCategory < ApplicationRecord
  has_many :songs
  before_destroy :check

  def to_s
    name
  end

  validates :name, presence: true

  private

  def check
    if songs.count > 0
      errors.add_to_base("Kategorin kan inte raderas eftersom den innehåller sånger")
      return false
    end
  end
end
