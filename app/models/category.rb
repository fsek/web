class Category < ApplicationRecord
  GENERAL = 'general'.freeze
  USE_CASES = [GENERAL, 'BlogPost', 'Event', 'News']
  has_many :categorizations, dependent: :destroy

  translates(:title)
  globalize_accessors(locales: [:en, :sv], attributes: [:title])

  validates :title, :slug, presence: true, uniqueness: true
  validates :slug, format: { with: /\A[a-z0-9_-]+\z/,
                             allow_blank: true,
                             message: I18n.t('model.category.slug_format') }
  validate :use_cases
  scope :by_type, -> (type) do
    includes(:categorizations).
      where(categorizations: { categorizable_type: type })
  end

  scope :by_title, -> do
    includes(:translations).
      with_locales(I18n.available_locales).
      order('category_translations.title ASC')
  end

  scope :for_use_case, -> (use_case) do
    where(use_case: [use_case, 'general'])
  end

  def self.slugs
    order(:slug).select(:slug).distinct.pluck(:slug)
  end

  def to_s
    title || id
  end

  def to_param
    slug || id
  end

  def allowed_use_case?(categorizable)
    use_case == GENERAL || categorizable == use_case
  end

  private

  def use_cases
    return if use_case == GENERAL

    if !USE_CASES.include?(use_case)
      errors.add(:use_case, I18n.t('model.category.not_allowed_use_case'))
    end
  end
end
