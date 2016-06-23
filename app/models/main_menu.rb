class MainMenu < ActiveRecord::Base
  has_many :menus, dependent: :destroy

  translates(:name)
  globalize_accessors(locales: [:en, :sv], attributes: [:name])

  validates :name, presence: true
  scope :index, -> { order(index: :asc) }

  def to_s
    name
  end

  def partial_path
    mega ? '/main_menu/mega_menu' : '/main_menu/small_menu'
  end
end
