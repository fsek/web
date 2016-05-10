# encoding:UTF-8
class Admin::CafeShiftsController < Admin::BaseController
  load_permissions_then_authorize_resource

  def show
    cafe_shift = CafeShift.find(params[:id])
    cafe_shift.cafe_worker || cafe_shift.build_cafe_worker
    @cafe_view = CafeViewObject.new(users: User.all_firstname,
                                    councils: Council.titles,
                                    shift: cafe_shift)
  end

  def edit
    @cafe_shift = CafeShift.find(params[:id])
  end

  def new
    @cafe_shift = CafeShift.new
  end

  def create
    @cafe_shift = CafeShift.new(shift_params)
    if @cafe_shift.save
      redirect_to admin_cafe_shift_path(@cafe_shift), notice: alert_create(CafeShift)
    else
      render :new, status: 422
    end
  end

  def update
    @cafe_shift = CafeShift.find(params[:id])
    if @cafe_shift.update(shift_params)
      redirect_to admin_cafe_shift_path(@cafe_shift), notice: alert_update(CafeShift)
    else
      render :edit, status: 422
    end
  end

  def destroy
    shift = CafeShift.find(params[:id])
    @id = shift.id
    shift.destroy!
    respond_to do |format|
      format.html { redirect_to admin_cafe_shifts_path, notice: alert_destroy(CafeShift) }
      format.js
    end
  end

  def setup
    @cafe_shift = CafeShift.new
  end

  def setup_create
    @cafe_shift = CafeShift.new(shift_params)
    if CafeService.setup(@cafe_shift)
      redirect_to(admin_cafe_shifts_path, notice: alert_create(CafeShift))
    else
      flash[:alert] = I18n.t('cafe_shift.setup_error')
      render :setup, status: 422
    end
  end

  private

  def shift_params
    params.require(:cafe_shift).permit(:start, :pass, :lp, :lv, :lv_last, :setup_mode)
  end
end
