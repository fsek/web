class Constant < ActiveRecord::Base
  validates_presence_of :name, :value
  validates_uniqueness_of :name

  def self.get(name)
    c = Constant.where(name: name).first
    c && c.value || ''
  end
end
