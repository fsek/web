# encoding:UTF-8
class Admin::WorkPostsController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    if params[:all].present?
      posts = WorkPost.all
    else
      posts = WorkPost.by_deadline
    end

    @work_portal = WorkPortal.new(grid: initialize_grid(posts,
                                                        include: :user,
                                                        order: 'updated_at',
                                                        order_direction: 'desc'))
  end

  def new
    @work_portal = WorkPortal.new(current_post: WorkPost.new)
  end

  def edit
    @work_portal = WorkPortal.new(current_post: WorkPost.find(params[:id]))
  end

  def create
    @work_portal = WorkPortal.new(current_post: WorkPost.new(work_post_params))
    @work_portal.current_post.user = current_user

    if @work_portal.current_post.save
      redirect_to(edit_admin_work_post_path(@work_portal.current_post),
                  notice: alert_create(WorkPost))
    else
      render :new, status: 422
    end
  end

  def update
    @work_portal = WorkPortal.new(current_post: WorkPost.find(params[:id]))
    @work_portal.current_post.user = current_user

    if @work_portal.current_post.update(work_post_params)
      redirect_to(edit_admin_work_post_path(@work_portal.current_post),
                  notice: alert_update(WorkPost))
    else
      render :edit, status: 422
    end
  end

  def destroy
    work_post = WorkPost.find(params[:id])

    work_post.destroy!
    redirect_to admin_work_posts_path, notice: alert_destroy(WorkPost)
  end

  private

  def work_post_params
    params.require(:work_post).permit(:title, :description, :company, :deadline,
                                      :field, :target_group, :visible, :publish,
                                      :image, :remove_image, :link, :kind)
  end
end
