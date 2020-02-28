class LockersController < ApplicationController
  load_permissions_then_authorize_resource

  def index
    @lockers = initialize_grid(Locker.all, order: 'name', order_direction: 'asc')
  end

  def show
  end

  def rented
    @users_rented_lockers = initialize_grid(LockerRenter.where(user_id: current_user.id))
  end

  def setup
    @locker_renter = LockerRenter.new
  end

  def setup_create
    @locker_renter = LockerRenter.new(locker_renter_params)
    templocker = @locker_renter.locker
    if templocker.occupied
      redirect_to lockers_path, notice: alert_danger("OOps upptagen")
    elsif @locker_renter.save
      templocker.update(occupied: true)
      redirect_to lockers_path, notice: alert_update(Locker)
    else
      redirect_to lockers_path, notice: alert_danger("oops inget")
    end
  end

  def locker_renter_params
    params.require(:locker_renter).permit(:locker_id, :user_id, :semester)
  end

  def queue
    @queued_renter = QueuedRenter.new
  end

  def queue_create
    @queued_renter = QueuedRenter.new(queued_renter_params)
    if @queued_renter.save
      redirect_to lockers_path
    else
      redirect_to lockers_path
    end
  end

  def queued_renter_params
    params.require(:queued_renter).permit(:semester)
  end
end
