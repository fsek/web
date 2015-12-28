# encoding:UTF-8
class Admin::CafeController < ApplicationController
  skip_authorization
  before_action :authorize

  def index
    @cafe_shift_grid = initialize_grid(CafeShift,
                                       include: :user, order: :start,
                                       conditions: ['start >= ?', Time.zone.now.beginning_of_day])
  end

  def overview
    @cafe_shift_grid = initialize_grid(CafeShift.all_start.with_worker)
  end

  private

  def authorize
    authorize! :manage, CafeShift
  end
end
