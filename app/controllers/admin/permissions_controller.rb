# encoding: UTF-8
class Admin::PermissionsController < Admin::BaseController
  load_permissions_and_authorize_resource
  load_and_authorize_resource :post

  def index
    @posts = Post.includes(:permissions).by_title
  end

  def show_post
    @permissions = Permission.subject
  end

  def update_post
    if @post.set_permissions(permission_params)
      redirect_to admin_permissions_path, notice: alert_update(Post)
    else
      render :show_post, status: 422
    end
  end

  private

  def permission_params
    params.require(:post).permit(permission_ids: [])
  end
end
