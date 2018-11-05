class CafeController < ApplicationController
  skip_authorization

  def index
    authorize!(:index, :cafe)
  end

  def competition
    authorize!(:index, :cafe)

    lp_current = CafeShift.order(start: :desc).first.try(:lp) || 1
    lp = params[:lp] || lp_current

    if can_administrate?(:edit, CafeShift)
      amount = params[:amount] || 10
    else
      amount = 10
    end

    @competition = CafeCompetition.new(lp: lp, year: competition_year, amount: amount)
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
