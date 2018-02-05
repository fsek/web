# encoding: UTF-8
class CafeWorkersController < ApplicationController
  load_permissions_and_authorize_resource
  load_and_authorize_resource :cafe_shift, parent: true

  def new
    cafe_shift = CafeShift.find(params[:cafe_shift_id])
    cafe_shift.cafe_worker || cafe_shift.build_cafe_worker
    @cafe_view = CafeViewObject.new(shift: cafe_shift,
                                    councils: Council.by_title)
    render template: '/cafe_shifts/show'
  end

  def create
    cafe_shift = CafeShift.find(params[:cafe_shift_id])
    cafe_shift.build_cafe_worker(cafe_worker_params)
    @cafe_view = CafeViewObject.new(shift: cafe_shift,
                                    councils: Council.by_title)

    if cafe_shift.cafe_worker.save
      redirect_to(cafe_shift_path(cafe_shift),
                  notice: I18n.t('model.cafe_worker.created'))
    else
      render template: '/cafe_shifts/show', status: 422
    end
  end

  def update
    cafe_shift = CafeShift.find(params[:cafe_shift_id])
    cafe_worker = CafeWorker.find(params[:id])
    @cafe_view = CafeViewObject.new(shift: cafe_shift,
                                    councils: Council.by_title)
    if cafe_worker.update(cafe_worker_params)
      redirect_to(cafe_shift_path(cafe_shift),
                  notice: I18n.t('model.cafe_worker.updated'))
    else
      render template: '/cafe_shifts/show', status: 422
    end
  end

  def destroy
    cafe_shift = CafeShift.find(params[:cafe_shift_id])
    cafe_worker = CafeWorker.find(params[:id])
    user = cafe_worker.user
    if cafe_worker.destroy
      CafeMailer.destroy_email(user, cafe_shift).deliver_now
      redirect_to(cafe_shift_path(cafe_shift),
                  notice: I18n.t('model.cafe_worker.destroyed'))
    else
      redirect_to(cafe_shift_path(cafe_shift))
    end
  end

  private

  def cafe_worker_params
    params.require(:cafe_worker).permit(:user_id, :competition, :group, council_ids: [])
  end
end
