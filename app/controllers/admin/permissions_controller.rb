# encoding: UTF-8
class Admin::PermissionsController < ApplicationController
  load_permissions_and_authorize_resource
  load_and_authorize_resource :post
  before_action :can_manage_permissions, only: \
    [:index, :show_post]
  before_action :set_permissions

  def index
    @posts = Post.title
  end

  def show_post
    @permissions = Permission.subject
    @post_permissions = @post.permissions.map(&:id)
  end

  def update_post
    if @post.set_permissions(permission_params)
      redirect_to index_admin_permissions_path, notice: alert_update(Post)
    else
      render :show_post, status: 422
    end
  end

  def permission_params
    params.require(:post).permit(permission_ids: [])
  end

  def can_manage_permissions
    authorize!(:manage, PermissionPost)
  end

  def set_permissions
    @permissions = Permission.all
  end
end
