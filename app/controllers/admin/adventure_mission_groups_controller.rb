class Admin::AdventureMissionGroupsController < Admin::BaseController
  load_permissions_and_authorize_resource
  load_and_authorize_resource :adventure, :except => [:update]
  load_and_authorize_resource :group, :only => [:index]

  def index
    if adventure_mission_group_params[:pending].nil?
      @adventure_mission_group.pending = false
    else
      @adventure_mission_group.pending = adventure_mission_group_params[:pending]
    end
    @grid = initialize_grid(@adventure_mission_groups,
                            include: [:group, :adventure_mission],
                            per_page: 30)
  end

  def edit
    @group = @adventure_mission_group.group
  end

  def update
    # No validation here since there are admins doing this
    @adventure_mission_group.points = adventure_mission_group_params[:points]
    @adventure_mission_group.pending = adventure_mission_group_params[:pending]
    if @adventure_mission_group.save(validate: false)
      redirect_to admin_group_adventures_path(group_id: @adventure_mission_group.group.id),
                  notice: alert_success(t('.success'))
    else
      redirect_to edit_admin_adventure_mission_group_path(group: @group),
                  alert: alert_errors(@adventure_mission_group.errors.full_messages)
    end
  end

  def destroy
    @group = @adventure_mission_group.group
    if @adventure_mission_group.destroy
      redirect_to admin_group_adventures_path(@group), notice: alert_success(t('.success'))
    else
      redirect_to edit_admin_group_adventure_mission_group_path(@group, @adventure_mission_group),
                  alert: alert_errors(@adventure_mission_group.errors.full_messages)
    end
  end

  def accept
    @adventure_mission_group = AdventureMissionGroup.find(params[:adventure_mission_group_id])
    if @adventure_mission_group.update_attribute(:pending, false)
      redirect_to admin_adventure_adventure_mission_groups_path(@adventure),
                  notice: alert_success(t('.success'))
    else
      redirect_to admin_adventure_adventure_mission_groups_path(@adventure),
                  alert: alert_danger(t('.fail'))
    end
  end

  private

  def adventure_mission_group_params
    params.require(:adventure_mission_group).permit(:points, :pending, :adventure)
  end
end
