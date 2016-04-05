class Tool < ActiveRecord::Base
  has_many :tool_rentings

  validates :title, :description, :total, presence: true
  validates :total, numericality: { greater_than: 0 }
  validate :total_greater_than_rented

  def free
    total - tool_rentings.where(returned: false).size
  end

  private

  def total_greater_than_rented
    rented = tool_rentings.where(returned: false).size
    if total.present? && total < rented
      errors.add(:total, 'not allowed to change total below rented tools')
    end
  end
end
