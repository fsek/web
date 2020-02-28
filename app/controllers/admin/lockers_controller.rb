class Admin::LockersController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @lockers = initialize_grid(Locker.all, order: 'name', order_direction: 'asc')
  end

  def new
    @locker = Locker.new
  end

  def create
    @locker = Locker.new(locker_params)
    if @locker.save
      redirect_to admin_lockers_path
    else
      render 'new'
    end
  end

  def destroy
    @locker = Locker.find(params[:id])
    if @locker.occupied
      redirect_to admin_lockers_path, notice: alert_danger("NO deletus when utlånad")
    elsif @locker.destroy
      redirect_to admin_lockers_path, notice: alert_destroy(Locker)
    else
      redirect_to admin_lockers_path, notice: alert_danger("bruh")
    end
  end

  def locker_params
    params.require(:locker).permit(:name, :room, :users)
  end

  def update
    @locker = Locker.find(params[:id])
    if @locker.update(locker_params)
      redirect_to admin_lockers_path, notice: alert_update(Locker)
    else
      redirect_to edit_admin_lockers_path, notice: alert_danger("bruh")
    end
  end

  #Handles renting of lockers
  def setup
    @locker_renter = LockerRenter.new
  end

  def setup_create
    @locker_renter = LockerRenter.new(locker_renter_params)
    templocker = @locker_renter.locker
    if templocker.occupied
      redirect_to admin_lockers_path, notice: alert_danger("OOps upptagen")
    elsif @locker_renter.save
      templocker.update(occupied: true)
      redirect_to admin_lockers_path, notice: alert_update("Now is utlånad")
    else
      redirect_to admin_lockers_path
    end
  end

  def destroy_locker_renter
    LockerRenterService.destroy_locker_renter(LockerRenter.find(params[:locker_id]))
    redirect_to admin_lockers_path, notice: alert_destroy(LockerRenter)
  end

  def toggle_reserved
    locker_renter = LockerRenter.find(params[:locker_id])
    bool = !locker_renter.reserved
    if locker_renter.update_attribute(:reserved, bool)
      redirect_to rented_admin_lockers_path, notice: alert_update(Locker)
    else
      redirect_to rented_admin_lockers_path, notice: alert_danger("bruh")
    end
  end

  def toggle_payed_for
    locker_renter = LockerRenter.find(params[:locker_id])
    bool = !locker_renter.payed_for
    if locker_renter.update_attribute(:payed_for, bool)
      redirect_to rented_admin_lockers_path, notice: alert_update(Locker)
    else
      redirect_to rented_admin_lockers_path, notice: alert_danger("bruh")
    end
  end

  def rented
    @locker_renters = initialize_grid(LockerRenter.where(reserved: false), order_direction: 'asc')
    @locker_renters_reserved = initialize_grid(LockerRenter.where(reserved: true), order_direction: 'asc')
    @locker_renters_payed_for = initialize_grid(LockerRenter.where(payed_for: true, reserved: true), order_direction: 'asc')
  end
 
  def locker_renter_params
    params.require(:locker_renter).permit(:locker_id, :user_id,:semester,:reserved,:payed_for)
  end

  def create_from_queued
    @queued_renters = QueuedRenter.all
    while Locker.free != []
      crete
    end
  end
end
