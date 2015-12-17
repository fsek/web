# encoding:UTF-8
class Admin::CafeController < ApplicationController
  skip_authorization

  def index
  end

  def overview
  end

  def competition
  end

  def ladybug
    authorize!(:ladybuyg, CafeShift)
    if (date = params[:ladybug][:date]).present?
      @date = Time.zone.parse(date)
    else
      @date = Time.zone.now
    end
    @cafe_shifts = CafeShift.between(@date.beginning_of_day, @date.end_of_day).ascending
  end
end
