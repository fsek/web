class Menu < ApplicationRecord
  belongs_to :main_menu

  translates(:name)
  globalize_accessors(locales: [:en, :sv], attributes: [:name])

  scope :in_order, -> { order(column: :asc, index: :asc).where(visible: true) }

  validates :name, :link, :main_menu_id, :column, presence: true
  validates :column, inclusion: 1..4

  def to_s
    name
  end

  def to_partial_path
    if header?
      '/menus/menu_header'
    else
      super
    end
  end
end
