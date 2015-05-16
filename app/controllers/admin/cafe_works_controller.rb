# encoding:UTF-8
class Admin::CafeWorksController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :authorize
  before_action :set_lv, only: [:setup_create]
  before_action :set_new_cafe_work, only: [:setup, :setup_create]
  before_action :set_cafe_setup, only: [:setup_create]

  def show
  end

  def new
  end

  def edit
  end

  def overview
    @cafe_works = CafeWork.all_work_day
  end

  def create
    flash[:notice] = alert_create(CafeWork) if @cafe_work.save
    redirect_to [:admin, @cafe_work]
  end

  def update
    if @cafe_work.update(cafe_work_params)
      redirect_to [:admin, @cafe_work], notice: alert_update(CafeWork)
    else
      render action: :edit
    end
  end

  def destroy
    # Id used to hide element
    @id = @cafe_work.id
    @cafe_work.destroy
    respond_to do |format|
      format.html { redirect_to :admin_hilbert, alert: alert_destroy(CafeWork) }
      format.js
    end
  end

  def remove_worker
    if !@cafe_work.clear_worker
      render action: show, notice: 'Lyckades inte'
    end
  end

  def setup
  end

  def setup_create
    if preview?
      @cafe_works = @r.preview(@lv_first, @lv_last)
      @cafe_work.valid?
    else
      @r.setup(@lv_first, @lv_last)
      flash[:notice] = 'Cafejobben skapades'
    end
    render :setup
  end

  def index
    @faqs = Faq.category(:Hilbert).answered
    @faq_unanswered = Faq.category(:Hilbert).where(answer: '').count
    @cwork_grid = initialize_grid(CafeWork.all)
  end

  private

  def authorize
    authorize! :manage, CafeWork
  end

  def cafe_work_params
    params.require(:cafe_work).permit(:work_day, :pass, :lp, :lv, :lv_first, :lv_last, :d_year)
  end

  def set_new_cafe_work
    if params[:cafe_work].present?
      @cafe_work = CafeWork.new(cafe_work_params)
    else
      @cafe_work = CafeWork.new
    end
  end

  def set_cafe_setup
    if cafe_work_params[:work_day].present? && cafe_work_params[:lp].present?
      @r = CafeSetupWeek.new(Time.zone.parse(cafe_work_params[:work_day]), cafe_work_params[:lp])
    end
  end

  def set_lv
    @lv_first = cafe_work_params[:lv_first] || 0
    @lv_last = cafe_work_params[:lv_last] || 0
  end

  def preview?
    params[:commit] == I18n.t(:preview)
  end
end
