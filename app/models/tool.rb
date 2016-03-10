class Tool < ActiveRecord::Base
  validates :title, :description, :total, presence: true
  validates :total, numericality: { greater_than: 0 }

  def free
    total - rents
  end
end
