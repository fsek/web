class Menu < ActiveRecord::Base
  scope :index, -> {order(index: :asc).where(visible: true)}
end
