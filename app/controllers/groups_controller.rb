class GroupsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    @introduction = Introduction.find_by(id: params[:introduction_id]) || Introduction.current
    @introductions = Introduction.all_except(@introduction)
    @grid = initialize_grid(Group.regular.where(introduction: @introduction),
                            include: :users,
                            order: 'number')
  end

  def show
    group = Group.for_show.find(params[:id])
    @group_view = GroupView.new(group)
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])

    if @group.update(group_params)
      redirect_to group_path(@group), notice: alert_update(Group)
    else
      render :edit, status: 422
    end
  end

  private

  def group_params
    params.require(:group).permit(user_ids: [])
  end
end
