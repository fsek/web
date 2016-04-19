class Category < ActiveRecord::Base
  has_many :categorizations, dependent: :destroy

  validates :title, :slug, presence: true, uniqueness: true
  validates :slug, format: { with: /\A[a-z0-9_-]+\z/,
                             allow_blank: true,
                             message: I18n.t('category.slug_format') }
  scope :by_type, -> (type) do
    includes(:categorizations).
      where(categorizations: { categorizable_type: type })
  end

  def to_s
    title || id
  end

  def to_param
    slug || id
  end
end
