class Locker < ApplicationRecord
  validates :name, :room, presence: true

  has_one :locker_renters
  has_one :users, through: :locker_renters


  def self.free
    @locker = []
    Locker.all.each do |k|
      if !k.occupied
        @locker.push(k)
      end
    end
    @locker
  end
end
