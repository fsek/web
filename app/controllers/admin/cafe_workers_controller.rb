# encoding: UTF-8
class Admin::CafeWorkersController < Admin::BaseController
  load_permissions_and_authorize_resource
  load_and_authorize_resource :cafe_shift, parent: true

  def new
    cafe_shift = CafeShift.find(params[:cafe_shift_id])
    cafe_shift.cafe_worker || cafe_shift.build_cafe_worker

    @cafe_view = CafeViewObject.new(users: User.by_firstname.confirmed,
                                    councils: Council.by_title,
                                    shift: cafe_shift)
  end

  def create
    cafe_shift = CafeShift.find(params[:cafe_shift_id])
    cafe_shift.build_cafe_worker(cafe_worker_params)

    @cafe_view = CafeViewObject.new(users: User.by_firstname.confirmed,
                                    councils: Council.by_title,
                                    shift: cafe_shift)
    if cafe_shift.cafe_worker.save
      redirect_to(admin_cafe_shift_path(@cafe_shift), notice: alert_create(CafeWorker))
    else
      render :new, status: 422
    end
  end

  def update
    cafe_shift = CafeShift.find(params[:cafe_shift_id])
    cafe_worker = CafeWorker.find(params[:id])
    @cafe_view = CafeViewObject.new(users: User.by_firstname.confirmed,
                                    councils: Council.by_title,
                                    shift: cafe_shift)
    if cafe_worker.update(cafe_worker_params)
      redirect_to(admin_cafe_shift_path(cafe_shift), notice: alert_update(CafeWorker))
    else
      render :new, status: 422
    end
  end

  def destroy
    cafe_shift = CafeShift.find(params[:cafe_shift_id])
    cafe_worker = CafeWorker.find(params[:id])
    if cafe_worker.destroy
      redirect_to(admin_cafe_shift_path(cafe_shift), notice: alert_destroy(CafeWorker))
    else
      redirect_to(admin_cafe_shift_path(cafe_shift))
    end
  end

  private

  def cafe_worker_params
    params.require(:cafe_worker).permit(:user_id, :competition, :group, council_ids: [])
  end
end
