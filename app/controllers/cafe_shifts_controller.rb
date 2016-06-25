# encoding:UTF-8
class CafeShiftsController < ApplicationController
  load_permissions_and_authorize_resource

  def show
    cafe_shift = CafeShift.find(params[:id])
    cafe_shift.cafe_worker || cafe_shift.build_cafe_worker
    @cafe_view = CafeViewObject.new(shift: cafe_shift,
                                    councils: Council.by_title)
  end

  def feed
    render json: CafeQueries.between(params[:start], params[:end]).
      as_json(user: current_user)
  end
end
