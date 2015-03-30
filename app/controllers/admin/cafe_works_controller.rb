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

  def create
    flash[:notice] = 'Cafejobbet skapades, success.' if @cafe_work.save
    redirect_to [:admin, @cafe_work]
  end

  def update
    if @cafe_work.update(cafe_work_params)
      flash[:notice] = 'Cafejobbet uppdaterades'
      redirect_to [:admin, @cafe_work]
    else
      render action: :edit
    end
  end

  def destroy
    # Id used to hide element
    @id = @cafe_work.id
    @cafe_work.destroy
    respond_to do |format|
      format.html { redirect_to :admin_hilbert, notice: 'Cafepasset raderades.' }
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
    elsif save?
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
    params.require(:cafe_work).permit(:work_day, :pass, :lp, :lv)
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
    @lv_first = (params[:lv_first].present?) ? params[:lv_first].to_i : 0
    @lv_last = (params[:lv_last].present?) ? params[:lv_last].to_i : 0
  end

  def preview?
    params[:commit] == 'Förhandsgranska'
  end

  def save?
    params[:commit] == 'Spara'
  end
end
