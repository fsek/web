class Constant < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :value, presence: true

  def self.get(name)
    c = Constant.where(name: name).first
    c && c.value || ''
  end
end
