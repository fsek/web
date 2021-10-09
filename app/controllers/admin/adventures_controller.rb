class Admin::AdventuresController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    set_adventures
    @grid = initialize_grid(@adventures, order: :start_date)
  end

  def new
  end

  def create
    if @adventure.save
      redirect_to admin_adventures_path, notice: alert_create(Adventure)
    else
      render :new, status: 422
    end
  end

  def edit
  end

  def update
    old_adventure = @adventure.dup
    if @adventure.update(adventure_params)
      AdventureService.update_locking(old_adventure, @adventure)
      redirect_to(admin_adventures_path, notice: alert_update(Adventure))
    else
      redirect_to edit_admin_adventure_path(@adventure),
                  alert: alert_errors(@adventure.errors.full_messages)
    end
  end

  def lock
    @adventure = Adventure.find(params[:adventure_id])
    if @adventure.adventure_missions.update_all(locked: true)
      redirect_to admin_adventure_adventure_missions_path, notice: alert_success(t('.success'))
    else
      redirect_to admin_adventure_adventure_missions_path, alert: alert_danger(t('.fail'))
    end
  end

  def unlock
    @adventure = Adventure.find(params[:adventure_id])
    if @adventure.adventure_missions.update_all(locked: false)
      redirect_to admin_adventure_adventure_missions_path, notice: alert_success(t('.success'))
    else
      redirect_to admin_adventure_adventure_missions_path, notice: alert_danger(t('.fail'))
    end
  end

  def destroy
    if @adventure.destroy
      redirect_to(admin_adventures_path, notice: alert_destroy(Adventure))
    else
      redirect_to edit_admin_adventure_path(@adventure),
                  alert: alert_errors(@adventure.errors.full_messages)
    end
  end

  private

  def set_adventures
    if params[:introduction].present?
      introduction = Introduction.find_by!(slug: params[:introduction])
      @adventures = introduction.adventures
    else
      @adventures = Adventure.all
    end
  end

  def adventure_params
    params.require(:adventure).permit(:title_sv, :title_en, :content_sv, :content_en,
                                      :max_points, :start_date, :end_date,
                                      :video, :publish_results, :introduction_id)
  end
end
