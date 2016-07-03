class Introduction < ActiveRecord::Base
  validates :title, :start, :stop, :slug, presence: true
  validates :slug, uniqueness: true,
                   presence: true,
                   format: { with: /\A[a-z0-9_-]+\z/ }
  validates :current, uniqueness: true, if: :current
  translates(:title, :description)
  globalize_accessors(locales: [:en, :sv],
                      attributes: [:title, :description])

  acts_as_paranoid

  def to_param
    slug
  end
end
