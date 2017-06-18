class Categorization < ApplicationRecord
  belongs_to :category
  belongs_to :categorizable, polymorphic: true, touch: true

  validates :category, :categorizable, presence: true
  validates :categorizable_id, uniqueness: { scope: [:category,
                                                     :categorizable_type],
                                             message: I18n.t('model.category.already_added') }
  validate :use_case

  private

  def use_case
    if category.present? && !category.allowed_use_case?(categorizable_type)
      errors.add(:categorizable, 'Not allowed use case')
    end
  end
end
