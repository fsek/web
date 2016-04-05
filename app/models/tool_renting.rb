class ToolRenting < ActiveRecord::Base
  belongs_to :tool

  validates :renter, :tool, :return_date, presence: true
  validate :there_are_free_tools

  private

  def there_are_free_tools
    if !persisted? && tool.present? && tool.free == 0
      errors.add(:returned, 'no more tools to rent')
    end
  end
end
