# encoding:UTF-8
class WorkPostsController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :set_edit

  def index
    @work_posts = WorkPost.publish
    @work_post_grid = initialize_grid(WorkPost.publish)
    @not_published_grid = initialize_grid(WorkPost.unpublish)
    if WorkPost.unpublish.count > 0
      @edit_grid = true
    end
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @work_post.responsible = current_user.id
    if @work_post.save
      redirect_to work_posts_path, notice: alert_create(WorkPost)
    else
      render action: :new
    end
  end

  def update
    if @work_post.update(work_post_params)
      redirect_to work_posts_path, notice: alert_update(WorkPost)
    else
      render action: :edit
    end
  end

  def destroy
    @work_post.destroy
    redirect_to work_posts_path, notice: alert_destroy(WorkPost)
  end

  private

  def set_edit
    @edit = can?(:manage, WorkPost)
  end

  def work_post_params
    params.fetch(:work_post).permit(:title, :description, :company, :deadline,
                                    :kind, :for, :visible, :publish, :picture,
                                    :category, :link)
  end
end
