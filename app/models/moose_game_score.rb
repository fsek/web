class MooseGameScore < ApplicationRecord
  validates :score, presence: true 
  belongs_to :user
  validates :user, uniqueness: true
  
end 