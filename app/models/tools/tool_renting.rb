class ToolRenting < ApplicationRecord
  belongs_to :tool

  validates :user_id, :tool, :return_date, presence: true
  validate :there_are_free_tools
  validate :return_date_lesser_than_today

  private

  def there_are_free_tools
    if !persisted? && tool.present? && tool.free == 0
      errors.add(:returned, I18n.t('model.tool_renting.no_more_tools'))
    end
  end

  def return_date_lesser_than_today
    if !persisted? && tool.present? && return_date < Date.today
      errors.add(:returned, I18n.t('model.tool_renting.return_date_lesser_than_today'))
    end
  end
end
