class SquadUser < ActiveRecord::Base
  belongs_to :squad
  belongs_to :user

  validates :squad, :user, presence: true
  validates :squad, uniqueness: { scope: :user }
end
