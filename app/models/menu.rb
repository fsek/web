# encoding: UTF-8
class Menu < ActiveRecord::Base
  GUILD = 'guild'.freeze
  MEMBER = 'members'.freeze
  COMPANY = 'companies'.freeze
  CONTACT = 'contact'.freeze

  scope :index, -> { order(index: :asc).where(visible: true) }

  def to_s
    name
  end
end
