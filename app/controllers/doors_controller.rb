class DoorsController < ApplicationController
  def index
    @door_grid = initialize_grid(Door)
  end

  def accesses
    @doors = Door.by_title
    @door = Door.includes(:posts).find(params[:id])
    @temp = @door.access_users.pluck(:user_id)
    render layout: false
  end

  private

  def door_params
    params.require(:door).permit(:title, post_ids: [])
  end
end
