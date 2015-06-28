class GroupsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @group.save
      redirect_to group_path(@group), notice: alert_create(Group)
    else
      render :new
    end
  end

  def update
    if @group.update(group_params)
      redirect_to group_path(@group), notice: alert_update(Group)
    else
      render :edit
    end
  end

  def destroy
    @group.destroy!
    redirect_to groups_url, notice: alert_destroy(Group)
  end

  private

  def group_params
    params.require(:group).permit(:title, :category,
                                  :description, :public)
  end
end
