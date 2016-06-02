# encoding: UTF-8
class Menu < ActiveRecord::Base
  translates(:name)
  globalize_accessors(locales: [:en, :sv],
                      attributes: [:name])

  GUILD = 'guild'.freeze
  MEMBER = 'members'.freeze
  COMPANY = 'companies'.freeze
  CONTACT = 'contact'.freeze

  scope :index, -> { order(index: :asc).where(visible: true) }
  validates :name, :link, :location, presence: true

  def to_s
    name
  end
end
