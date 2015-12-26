# encoding:UTF-8
class CafeController < ApplicationController
  skip_authorization

  def index
  end

  def overview
  end

  def competition
  end

  def ladybug
    authorize!(:ladybug, CafeShift)
    if params[:ladybug].present? && params[:ladybug][:date].present?
      @date = Time.zone.parse(params[:ladybug][:date])
    else
      @date = Time.zone.now
    end

    @cafe_shifts = CafeShift.between(@date.beginning_of_day,
                                     @date.end_of_day).ascending.includes(:user)
  end
end
