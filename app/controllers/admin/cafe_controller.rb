# encoding:UTF-8
class Admin::CafeController < Admin::BaseController
  authorize_resource class: false

  def index
    @cafe_shift_grid = initialize_grid(CafeShift,
                                       include: :user, order: :start,
                                       conditions: ['start >= ?', cafe_date])
  end

  def overview
    @cafe_shift_grid = initialize_grid(CafeShift.all_start.with_worker)
  end

  private

  def cafe_date
    if params[:cafe].present?
      params[:cafe][:date]
    else
      Time.zone.now.beginning_of_day
    end
  end
end
