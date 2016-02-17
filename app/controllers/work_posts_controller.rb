# encoding:UTF-8
class WorkPostsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    @work_portal = WorkPortal.new(work_posts: WorkPost.published)
    @work_portal.current_and_filter(filtering_params)
  end

  def show
    @work_post = WorkPost.published.find(params[:id])
  end

  private

  def filtering_params
    params.slice(:target, :field, :kind)
  end
end
