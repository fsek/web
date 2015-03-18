# encoding:UTF-8
class CafeWorksController < ApplicationController
  before_action :set_cafe_work, except: [:main, :nyckelpiga]
  before_action :councils, except: [:main, :nyckelpiga]
  before_action :nyckelpiga_auth, only: :nyckelpiga
  before_action :set_faqs, only: :main

  def show
    @cwork.load(current_user)
    @path = (@cwork.has_worker?) ? :update_worker : :add_worker
  end

  def authorize
    @authenticated = @cwork.authorize(worker_params[:access_code])
    @path = :update_worker
  end

  def update_worker
    if @cwork.update_worker(worker_params, current_user)
      flash[:notice] = 'Bokningen uppdaterades'
      redirect_to @cwork
    else
      render action: :show
    end
  end

  def add_worker
    flash[:notice] = 'Jobbare lades till' if @cwork.add_worker(worker_params, current_user)
    redirect_to @cwork
  end

  def remove_worker
    @removed = @cwork.remove_worker(current_user, worker_params[:access_code])
  end

  def main
    respond_to do |format|
      format.html { @lv = CafeWork.get_lv }
      format.json { render json: CafeWork.between(params[:start], params[:end]) }
    end
  end

  def nyckelpiga
    @date = (params[:date].present?) ? Time.zone.parse(params[:date]) : Time.zone.now
    @works = CafeWork.between(@date.beginning_of_day, @date.end_of_day).ascending
    @work_grid = initialize_grid(@works)
  end

  private

  def nyckelpiga_auth
    if current_user
      post = Post.where(title: 'Nyckelpiga').includes(:profiles).
          where(profiles: {id: current_user.profile.id}).first
    end
    if (post.nil?) && !((current_user) && (current_user.moderator?(:hilbert)))
      redirect_to(:hilbert, alert: 'Du saknar behörighet')
    end
  end

  def worker_params
    params.require(:cafe_work).permit(:profile_id, :name, :lastname, :phone, :email,
                                      :utskottskamp, :access_code, council_ids: [])
  end

  def councils
    @councils = Council.all
  end

  def set_cafe_work
    @cwork = CafeWork.find_by_id(params[:id])
    if @cwork.nil?
      redirect_to(:hilbert, notice: 'Hittade inget Cafejobb med det ID:t.')
    end
  end

  def set_faqs
    @faqs = Faq.category(:Hilbert).answered
  end
end
