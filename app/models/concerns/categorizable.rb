module Categorizable
  extend ActiveSupport::Concern

  included do
    has_many :categorizations, as: :categorizable
    has_many :categories, through: :categorizations

    scope :slug, ->(slug) { joins(:categories).where(categories: { slug: slug }) }
  end
end
