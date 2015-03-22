# encoding:UTF-8
class Admin::CafeWorksController < ApplicationController
  before_action :authenticate
  before_action :set_cafe_work, only: [:edit, :show, :update, :destroy, :remove_worker]
  before_action :new_cafe_work, only: [:new, :setup, :setup_create, :create]
  before_action :set_lv, only: [:setup_create]
  before_action :set_cafe_setup, only: [:setup_create]

  def show
  end

  def new
  end

  def edit
  end

  def create
    flash[:notice] = 'Cafejobbet skapades, success.' if @cwork.save
    redirect_to [:admin,@cwork]
  end

  def update
    if @cwork.update(c_w_params)
      flash[:notice] = 'Cafejobbet uppdaterades'
      redirect_to @cwork
    else
      render action: :edit
    end
  end

  def destroy
    # Id used to hide element
    @id = @cwork.id
    @cwork.destroy
    respond_to do |format|
      format.html { redirect_to :admin_hilbert, notice: 'Cafepasset raderades.' }
      format.js
    end
  end

  def remove_worker
    if !@cwork.clear_worker
      render action: show, notice: 'Lyckades inte'
    end
  end

  def setup
  end

  def setup_create
    if preview?
      @cworks = @r.preview(@lv_first, @lv_last)
    elsif save?
      @r.setup(@lv_first, @lv_last)
      flash[:notice] = 'Cafejobben skapades'
    end
    render 'setup'
  end

  def main
    @faqs = Faq.category(:Hilbert).answered
    @faq_unanswered = Faq.category(:Hilbert).where(answer: '').count
    @cwork_grid = initialize_grid(CafeWork.all)
  end

  private

  def authenticate
    if current_user.nil? || !current_user.moderator?(:cafejobb)
      redirect_to(:hilbert, alert: t('the_role.access_denied'))
    end
  end

  def c_w_params
    params.require(:cafe_work).permit(:work_day, :pass, :profile_id,
                                      :name, :lastname, :phone, :email, :lp, :lv,
                                      :utskottskamp, council_ids: [])
  end

  def set_cafe_work
    @cwork = CafeWork.find_by_id(params[:id])
    if !@cwork.present?
      redirect_to(:admin_cafe_works, notice: 'Hittade inget Cafejobb med det ID:t.')
    end
  end

  def set_cafe_setup
    if c_w_params[:work_day].present? && c_w_params[:lp].present?
      @r = CafeSetupWeek.new(Time.zone.parse(c_w_params[:work_day]), c_w_params[:lp])
    end
  end

  def new_cafe_work
    if params.present? && params[:cafe_work].present?
      @cwork = CafeWork.new(c_w_params)
    else
      @cwork = CafeWork.new
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
