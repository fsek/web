# encoding: UTF-8
class Menu < ActiveRecord::Base
  scope :index, -> {order(index: :asc).where(visible: true)}

  def to_s
    name
  end
end
