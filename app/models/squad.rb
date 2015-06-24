class Squad < ActiveRecord::Base
  has_many :squad_users
  has_many :users, through: :squad_users

  validates :title, :category, presence: true
end
