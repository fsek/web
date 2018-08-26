class Admin::AdventureMissionGroupsController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @grid = initialize_grid(@adventure_mission_groups,
                            include: [:adventure_mission, :group],
                            per_page: 30)
  end

  def edit
    @group = Group.find(params[:group_id])
  end

  def update
    if @adventure_mission_group.update!(adventure_mission_group_params)
      redirect_to admin_group_adventures_path(group: @group), notice: t('.success')
    else
      render :edit, alert: t('.failed')
    end
  end

  def destroy
    if @adventure_mission_group.destroy!
      redirect_to admin_group_adventures_path(group: @group), notice: t('.success')
    else
      render :edit, alert: t('.failed')
    end
  end

  private

  def adventure_mission_group_params
    params.require(:adventure_mission_group).permit(:points)
  end
end
