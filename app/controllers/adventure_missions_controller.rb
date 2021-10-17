class AdventureMissionsController < ApplicationController
  load_permissions_and_authorize_resource

  def show
    @group = current_user.groups.regular.last

    if @group.blank?
      redirect_to adventures_path, alert: t(".no_group")
    else
      @adventure_mission_group = @group.adventure_mission_groups.find_by(adventure_mission: @adventure_mission)
    end
  end
end
