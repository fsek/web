class AdventureMissionGroupsController < ApplicationController
  load_permissions_and_authorize_resource

  def new
    @adventure_mission = AdventureMission.find(params[:adventure_mission])
  end

  def create
    @group = current_user.groups.regular.last
    @adventure_mission_group = AdventureMissionGroup.new(adventure_mission_group_params)
    @adventure_mission_group.group = @group
    @adventure_mission = AdventureMission.find(adventure_mission_group_params[:adventure_mission_id])

    # If acceptance is not required, pending defaults to false
    @adventure_mission_group.pending = true if @adventure_mission.require_acceptance?

    if @adventure_mission_group.save
      redirect_to adventure_mission_path(@adventure_mission), notice: alert_success(t('.success'))
    else
      redirect_to new_adventure_mission_group_path(adventure_mission: @adventure_mission),
                  alert: alert_errors(@adventure_mission_group.errors.full_messages)
    end
  end

  def edit
    @adventure_mission = @adventure_mission_group.adventure_mission
  end

  def update
    @adventure_mission = AdventureMission.find(adventure_mission_group_params[:adventure_mission_id])
    if @adventure_mission_group.update(adventure_mission_group_params)
      redirect_to adventure_mission_path(@adventure_mission), notice: alert_success(t('.success'))
    else
      redirect_to edit_adventure_mission_group_path(@adventure_mission_group),
                  alert: alert_errors(@adventure_mission_group.errors.full_messages)
    end
  end

  def destroy
    @adventure_mission = @adventure_mission_group.adventure_mission

    if @adventure_mission_group.destroy
      redirect_to adventure_mission_path(@adventure_mission), notice: alert_danger(t('.success'))
    else
      redirect_to adventure_mission_path(@adventure_mission),
                  alert: alert_errors(@adventure_mission_group.errors.full_messages)
    end
  end

  private

  def adventure_mission_group_params
    params.require(:adventure_mission_group).permit(:points, :adventure_mission_id)
  end
end
