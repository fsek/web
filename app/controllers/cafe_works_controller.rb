# encoding:UTF-8
class CafeWorksController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :councils, except: [:index, :nyckelpiga]
  before_action :set_faqs, only: :index

  def show
    @cafe_work.load(current_user)
  end

  def update_worker
    if @cafe_work.add_or_update(worker_params, current_user)
      flash[:notice] = 'Bokningen uppdaterades - du arbetar!'
      redirect_to @cafe_work
    else
      render action: :show
    end
  end

  def remove_worker
    if @cafe_work.remove_worker(current_user)
      flash[:notice] = 'Du arbetar inte längre på passet'
      redirect_to @cafe_work
    else
      render action: :show
    end
  end

  def index
    respond_to do |format|
      format.html { @lv = CafeWork.get_lv }
      format.json { render json: CafeWork.between(params[:start], params[:end]) }
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
    params.require(:cafe_work).permit(:user_id, :name, :lastname, :phone, :email,
                                      :utskottskamp, council_ids: [])
  end

  def councils
    @councils = Council.all
  end

  def set_faqs
    @faqs = Faq.category(:Hilbert).answered
  end
end
