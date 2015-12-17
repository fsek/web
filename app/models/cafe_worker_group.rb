class CafeWorkerGroup < ActiveRecord::Base
  belongs_to :cafe_worker
  belongs_to :group

  validates :cafe_worker, :group, presence: true, uniqueness: true
end
