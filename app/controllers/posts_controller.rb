# encoding:UTF-8
class PostsController < ApplicationController
  load_permissions_and_authorize_resource
  load_and_authorize_resource :council, parent: true, find_by: :url
  before_action :can_manage_permissions, only: \
    [:edit_permissions, :update_permissions]
  before_action :set_permissions
  before_action :set_councils, only: [:new, :edit, :update, :create]
  before_action :set_profile, only: [:remove_profile, :add_profile]

  def remove_profile
    @post.remove_profile(@profile)
    redirect_to back,
                notice: %(#{@profile.full_name} har inte längre posten #{@post.title}.)
  end

  def add_profile
    if @post.add_profile(@profile)
      flash[:notice] = %(#{@profile.full_print} tilldelades #{@post})
    else
      flash[:alert] = %(Tilldelningen gick inte: #{@post.errors.full_messages})
    end
    redirect_to back
  end

  def index
    @posts = (@council.present?) ? @council.posts : Post.all
    @post_grid = initialize_grid(@posts)
  end

  def new
    @post = @council.posts.build
  end

  def edit
    @councils = Council.order(title: :asc)
  end

  def create
    @post = @council.posts.build(post_params)
    if @post.save
      redirect_to council_posts_path(@council), notice: alert_create_resource(Post)
    else
      render action: :new
    end
  end

  def update
    if @post.update(post_params)
      redirect_to edit_council_post_path(@post.council, @post), notice: alert_update_resource(Post)
    else
      render action: :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to council_posts_path(@council)
  end

  def show_permissions
    @posts = Post.all
  end

  def edit_permissions
    @permissions = Permission.all
    @post_permissions = @post.permissions.map &:id
    render :permissions
  end

  def update_permissions
    if @post.set_permissions(permission_params)
      redirect_to permissions_path, notice: alert_update_resource(Post)
    else
      render action: permission_path(@post)
    end
  end

  def display
  end

  def collapse
  end

  private

  def post_params
    params.require(:post).permit(:title, :limit, :recLimit,
                                 :description, :elected_by, :elected_at,
                                 :styrelse, :car_rent, :council_id)
  end

  def permission_params
    params.require(:post).permit(permission_ids: [])
  end

  def can_manage_permissions
    authorize! :manage, PermissionPost
  end

  def set_councils
    @councils = Council.order(title: :asc)
  end

  def set_permissions
    @permissions = Permission.all
  end

  def set_profile
    if @post.nil?
      @post = Post.find_by_id(params[:post_id])
    end
    @profile = Profile.find_by_id(params[:profile_id])
  end

  def back
    @council.present? ? council_posts_path(@council) : posts_path
  end
end
