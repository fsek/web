# encoding:UTF-8
class CafeWorksController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :councils, except: [:index, :nyckelpiga]
  before_action :set_faqs, only: :index

  def show
    if @cafe_work.user.present?
      @user = @cafe_work.user
    else
      @user = current_user
      @form = true
    end
    @cafe_work.valid?
  end

  def edit
  end

  def add_worker
    if @cafe_work.add_worker(worker_params, current_user)
      redirect_to cafe_work_path(@cafe_work), notice: I18n.t('cafe_work.worker_added')
    else
      @form = true
      render action: :show
    end
  end

  def update_worker
    if @cafe_work.update_worker(worker_params, current_user)
      redirect_to cafe_work_path(@cafe_work), notice: I18n.t('cafe_work.worker_updated')
    else
      render action: :show
    end
  end

  def remove_worker
    if @cafe_work.remove_worker(current_user)
      redirect_to cafe_work_path(@cafe_work), notice: I18n.t('cafe_work.worker_removed')
    else
      render action: :show
    end
  end

  def index
    respond_to do |format|
      format.html { @lv = CafeWork.get_lv }
      format.json { render json: CafeWork.between(params[:start], params[:end]).as_json(user: current_user) }
    end
  end

  def nyckelpiga
    authorize! :nyckelpiga, CafeWork
    @date = (params[:date].present?) ? Time.zone.parse(params[:date]) : Time.zone.now
    @work_grid = initialize_grid(CafeWork.between(@date.beginning_of_day,
                                                  @date.end_of_day).ascending)
  end

  private

  def worker_params
    params.require(:cafe_work).permit(:user_id, :utskottskamp, council_ids: [])
  end

  def councils
    @councils = Council.all
  end

  def set_faqs
    @faqs = Faq.category(:Hilbert).answered
  end
end
