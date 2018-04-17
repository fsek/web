class CafeWorkerCouncil < ApplicationRecord
  belongs_to :cafe_worker
  belongs_to :council

  validates :cafe_worker, :council, presence: true
  validates :council_id, uniqueness: { scope: :cafe_worker }
end
