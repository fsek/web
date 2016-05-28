class Categorization < ActiveRecord::Base
  belongs_to :category
  belongs_to :categorizable, polymorphic: true

  validates :category, :categorizable, presence: true
  validates :categorizable_id, uniqueness: { scope: [:category,
                                                     :categorizable_type],
                                             message: I18n.t('model.category.already_added') }
end
