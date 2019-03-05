class Api::AdventureMissionsController < Api::BaseController
  load_permissions_and_authorize_resource
  rescue_from ActiveRecord::RecordNotUnique, with: :notify_not_unique

  def show
    @adventure_mission = AdventureMission.find(params[:id])
    render json: @adventure_mission, serializer: Api::AdventureSerializer::Show
  end

  def finish_adventure_mission
    adventure_mission = AdventureMission.find(params[:adventure_mission_id])

    # fetch group from current_user so one can't specify other groups
    group = current_user.groups.regular.last

    points = params[:points].to_i
    if adventure_mission.locked?
      render json: { error: "Too late, the mission is locked.."}, status: 422 and return
    elsif points > adventure_mission.max_points
      render json: { error: "You can't get more than max points which is: #{adventure_mission.max_points}"}, status: 422 and return
    elsif points == 0
      render json: { error: "You can't get 0 points"}, status: 422 and return
    end

    # Doing both server and database auth to stop as soon as possible
    if group.adventure_mission_groups.pluck(:adventure_mission_id).include?(adventure_mission.id)
      render json: { error: 'You can only finish a mission once' }, status: 422 and return
    end

    # <finished> here is currently serving the exact same purpose as <created_at>
    adventure_mission_group = AdventureMissionGroup.new(adventure_mission: adventure_mission,
                                                         group: group,
                                                         points: points,
                                                         finished: Time.now)

    if adventure_mission_group.save
      render json: :ok, status: 200
    else
      render json: { error: adventure_mission_group.errors.full_messages }, status: 500
    end
  end

  def reset_adventure_mission
    adventure_mission = AdventureMission.find(params[:adventure_mission_id])

    if adventure_mission.locked?
      render json: { error: "You can't reset a locked mission"}, status: 422 and return
    end

    # fetch group from current_user so one can't specify other groups
    group = current_user.groups.regular.last

    unless group.adventure_mission_groups.pluck(:adventure_mission_id).include?(adventure_mission.id)
      render json: { error: 'You have not finished this mission yet' }, status: 422 and return
    end

    adventure_mission_group = group.adventure_mission_groups.where(adventure_mission: adventure_mission).first

    if adventure_mission_group.destroy!
      render json: :ok, status: 200
    else
      render json: { error: adventure_mission_group.errors.full_messages }, status: 500
    end
  end

  private

  def notify_not_unique
    render json: { error: 'You can only finish a mission once' }, status: 422
  end
end
