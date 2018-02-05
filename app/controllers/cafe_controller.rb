# encoding:UTF-8
class CafeController < ApplicationController
  skip_authorization

  def index
  end

  def competition
    lp_current = CafeShift.order(start: :desc).first.try(:lp) || 1
    lp = params[:lp] || lp_current
    @competition = CafeCompetition.new(lp: lp, year: competition_year)
  end

  def ladybug
    authorize_admin!(:ladybug, :cafe)

    if date = ladybug_date
      @date = Time.zone.parse(date)
    else
      @date = Time.zone.now
    end

    @cafe_shifts = CafeQueries.for_day(@date)
  end

  private

  def competition_year
    if params[:year].present?
      Time.zone.local(params[:year])
    else
      Time.zone.now
    end
  end

  def ladybug_date
    if params[:ladybug].present?
      params[:ladybug][:date]
    end
  end
end
