class MainMenu < ApplicationRecord
  has_many :menus, dependent: :destroy

  translates(:name)
  globalize_accessors(locales: [:en, :sv], attributes: [:name])

  validates :name, presence: true
  scope :by_index, -> { order(index: :asc).where(visible: true) }

  def to_s
    name
  end

  def partial_path
    mega ? '/main_menu/mega_menu' : '/main_menu/small_menu'
  end
end
