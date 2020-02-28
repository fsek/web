class LockerRenter < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :locker, required: true
  after_create(:schedule_remove)

  private

  def schedule_remove
    LockerRenterService.schedule_remove(self)
  end

end
