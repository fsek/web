class Admin::GroupsController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    set_groups
    @grid = initialize_grid(@groups,
                            include: :introduction,
                            order: 'introductions.start')
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to new_admin_group_path, notice: alert_create(Group)
    else
      render :new, status: 422
    end
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to admin_groups_path, notice: alert_update(Group)
    else
      render :edit, status: 422
    end
  end

  def destroy
    group = Group.find(params[:id])

    group.destroy!
    redirect_to admin_groups_path, notice: alert_destroy(Group)
  end

  def adventures
    @group = Group.find(params[:group_id])
    @adventure_mission_groups = AdventureMissionGroup.where(group: @group, pending: false)
    @grid = initialize_grid(@adventure_mission_groups,
                            include: :adventure_mission,
                            order: 'adventure_mission_groups.updated_at')
  end

  private

  def group_params
    params.require(:group).permit(:name, :number, :introduction_id, :group_type, user_ids: [])
  end

  def set_groups
    if params[:introduction].present?
      introduction = Introduction.find_by!(slug: params[:introduction])
      @groups = introduction.groups.order(number: :asc)
    else
      @groups = Group.order(number: :asc)
    end
  end
end
