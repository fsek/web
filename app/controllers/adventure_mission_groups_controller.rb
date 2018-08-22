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

    if @adventure_mission_group.save
      redirect_to adventure_adventure_mission_path(@adventure_mission.adventure, @adventure_mission), notice: t('.success')
    else
      render :new, status: 422, notice: t('.fail')
    end
  end

  def edit
    @adventure_mission = @adventure_mission_group.adventure_mission
  end

  def update
    @adventure_mission = AdventureMission.find(adventure_mission_group_params[:adventure_mission_id])
    if @adventure_mission_group.update(adventure_mission_group_params)
      redirect_to adventure_adventure_mission_path(@adventure_mission.adventure, @adventure_mission), notice:  t('.success')
    else
      render :edit, status: 422, notice: t('.fail')
    end
  end

  def destroy
    @adventure_mission = AdventureMission.find(params[:adventure_mission])
    if @adventure_mission_group.destroy
      redirect_to adventure_adventure_mission_path(@adventure_mission.adventure, @adventure_mission), notice:  t('.success')
    else
      redirect_to adventure_mission_path(@adventure_mission), notice: t('.fail')
    end
  end

  private

  def adventure_mission_group_params
    params.require(:adventure_mission_group).permit(:points, :adventure_mission_id)
  end

end
