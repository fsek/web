class Constant < ActiveRecord::Base
  # Validations
  validates :name, :value, presence: true
  validates :name, uniqueness: true

  def self.get(name)
    c = Constant.where(name: name).first
    c && c.value || ''
  end
end
