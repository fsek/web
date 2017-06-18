class ToolRenting < ApplicationRecord
  belongs_to :tool

  validates :renter, :tool, :return_date, presence: true
  validate :there_are_free_tools

  private

  def there_are_free_tools
    if !persisted? && tool.present? && tool.free == 0
      errors.add(:returned, I18n.t('model.tool_renting.no_more_tools'))
    end
  end
end
