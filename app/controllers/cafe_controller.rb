# encoding:UTF-8
class CafeController < ApplicationController
  skip_authorization

  def index
  end

  def competition
    lp = params[:lp] || '1'
    year = Time.zone.now
    if params[:year].present?
      year = Time.zone.local(params[:year])
    end

    @competition = CafeCompetition.new(CafeQueries.cafe_workers(lp, year),
                                       CafeQueries.working_users(lp, year),
                                       lp, year)
  end

  def ladybug
    authorize!(:ladybug, CafeShift)
    if params[:ladybug].present? && params[:ladybug][:date].present?
      @date = Time.zone.parse(params[:ladybug][:date])
    else
      @date = Time.zone.now
    end

    @cafe_shifts = CafeQueries.for_day(@date)
  end
end
