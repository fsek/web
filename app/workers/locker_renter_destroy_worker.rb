class LockerRenterDestroyWorker
  include Sidekiq::Worker
  sidekiq_options unique: :while_executing, unique_expiration: 60 * 24
  def perform(locker_renter_id)
    LockerRenterService.destroy_locker_renter(LockerRenter.find(locker_renter_id))
  end
end
