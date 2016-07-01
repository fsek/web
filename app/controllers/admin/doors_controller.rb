class Admin::DoorsController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @door_grid = initialize_grid(Door)
  end

  def new
    @door = Door.new
  end

  def edit
  end

  def create
    @door = Door.new(door_params)
    if @door.save
      redirect_to(edit_admin_door_path(@door), notice: alert_create(Door))
    else
      render :new, status: 422
    end
  end

  def update
    if @door.update(door_params)
      redirect_to(edit_admin_door_path(@door), notice: alert_update(Door))
    else
      render :edit, status: 422
    end
  end

  def destroy
    @door.destroy!

    redirect_to(admin_doors_path, notice: alert_destroy(Door))
  end

  def accesses
    @doors = Door.by_title
    @door = Door.includes(:posts).find(params[:id])
    @access_grid = initialize_grid(@door.users, order: 'student_id')
  end

  def post
    @post = Post.includes(:doors).find(params[:post_id])
    @post_grid = initialize_grid(@post.doors)
  end

  private

  def door_params
    params.require(:door).permit(:title, :slug, :description, post_ids: [])
  end
end
