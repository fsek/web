class Admin::AdventuresController < Admin::BaseController
  before_action :set_introduction
  load_permissions_and_authorize_resource through: :introduction

  def index
    @grid = initialize_grid(@adventures, order: :start_date, locale: :sv)
  end

  def new
    @adventure.groups = @introduction.groups.regular
  end

  def create
    @adventure.introduction = @introduction

    if @adventure.save
      redirect_to admin_introduction_adventures_path, notice: alert_create(Adventure)
    else
      render :new, status: 422
    end
  end

  def edit
  end

  def update
    if @adventure.update(adventure_params)
      redirect_to(admin_introduction_adventures_path, notice: alert_update(Adventure))
    else
      render :edit, status: 422
    end
  end

  def destroy
    @adventure.destroy!
    redirect_to(admin_introduction_adventures_path, notice: alert_destroy(Adventure))
  end

  def set_points
    @adventure = @introduction.adventures.includes(adventure_groups: :group).find(params[:id])
  end

  private

  def adventure_params
    params.require(:adventure).permit(:title_sv, :title_en, :content_sv, :content_en,
                                      :max_points, :start_date, :end_date,
                                      :video, :publish_results, group_ids: [],
                                      adventure_groups_attributes: [:id, :points, :_destroy])
  end

  def set_introduction
    @introduction = Introduction.find_by!(slug: params[:introduction_id])
  end
end
