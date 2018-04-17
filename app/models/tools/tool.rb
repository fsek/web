class Tool < ApplicationRecord
  has_many :tool_rentings

  validates :title, :total, presence: true
  validates :total, numericality: { greater_than: 0 }
  validate :total_greater_than_rented

  def free
    total - tool_rentings.where(returned: false).size
  end

  private

  def total_greater_than_rented
    rented = tool_rentings.where(returned: false).size
    if total.present? && total < rented
      errors.add(:total, I18n.t('model.tool.not_allowed_change_total'))
    end
  end
end
