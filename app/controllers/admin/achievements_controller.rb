class Admin::AchievementsController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @grid = initialize_grid(Achievement, order: :created_at)
  end

  def new
    @achievement = Achievement.new
  end

  def edit
    @achievement = Achievement.find(params[:id])
  end

  def create
    @achievement = Achievement.new(achievement_params)

    if @achievement.save
      redirect_to admin_achievements_path, notice: alert_create(Achievement)
    else
      render :new, status: 422
    end
  end

  def update
    @achievement = Achievement.find(params[:id])

    if @achievement.update(achievement_params)
      redirect_to admin_achievements_path, notice: alert_update(Achievement)
    else
      render :edit, status: 422
    end
  end

  def destroy
    achievement = Achievement.find(params[:id])
    achievement.destroy!

    redirect_to admin_achievements_path, notice: alert_destroy(Achievement)
  end

  private

  def achievement_params
    params.require(:achievement).permit(:name, :points)
  end
end
