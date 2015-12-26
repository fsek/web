# encoding:UTF-8
class Admin::CafeController < ApplicationController
  skip_authorization
  before_action :authorize

  def index
  end

  def overview
  end

  def competition
  end

  private

  def authorize
    authorize! :manage, CafeShift
  end
end
