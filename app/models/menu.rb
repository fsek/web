class Menu < ActiveRecord::Base
  belongs_to :main_menu

  translates(:name)
  globalize_accessors(locales: [:en, :sv], attributes: [:name])

  scope :index, -> { order(column: :asc, index: :asc).where(visible: true) }

  validates :name, :link, :main_menu_id, :column, presence: true
  validates :column, inclusion: 1..4

  def to_s
    name
  end
end
