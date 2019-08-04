class Admin::AdventureMissionGroupsController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @grid = initialize_grid(@adventure_mission_groups,
                            include: [:adventure_mission, :group],
                            per_page: 30)
  end

  def edit
    @group = @adventure_mission_group.group
  end

  def update
    # No validation here since there are admins doing this
    @adventure_mission_group.points = adventure_mission_group_params[:points]
    if @adventure_mission_group.save(validate: false)
      redirect_to admin_group_adventures_path(group_id: @adventure_mission_group.group.id),
                  notice: alert_success(t('.success'))
    else
      redirect_to edit_admin_adventure_mission_group_path(group: @group),
                  alert: alert_errors(@adventure_mission_group.errors.full_messages)
    end
  end

  def destroy
    group = @adventure_mission_group.group
    if @adventure_mission_group.delete
      redirect_to admin_group_adventures_path(group_id: group.id), notice: alert_success(t('.success'))
    else
      redirect_to edit_admin_adventure_mission_group_path(group: @group),
                  alert: alert_errors(@adventure_mission_group.errors.full_messages)
    end
  end

  private

  def adventure_mission_group_params
    params.require(:adventure_mission_group).permit(:points)
  end
end
