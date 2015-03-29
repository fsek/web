class CafeWorkCouncil < ActiveRecord::Base
  belongs_to :cafe_work
  belongs_to :council

  validates :cafe_work, :council, presence: true
end
