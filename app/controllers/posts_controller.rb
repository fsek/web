# encoding: UTF-8
class PostsController < ApplicationController
  load_permissions_and_authorize_resource
  load_and_authorize_resource :council, parent: true, find_by: :url
  before_action :prepare_index, only: [:index, :add_user, :remove_user]
  before_action :set_councils, only: [:new, :edit, :update, :create, :index]
  before_action :set_post_user, only: [:remove_user, :add_user]

  def add_user
    if PostUserService.create(@post_user)
      flash[:notice] = I18n.t('post.added', u: @post_user.user, p: @post_user.post)
      redirect_to back(@post_user.council)
    else
      render :index
    end
  end

  def remove_user
    PostUserService.destroy(@post_user)
    redirect_to back(@post_user.council),
      notice: I18n.t('post.user_removed', u: @post_user.user, p: @post_user.post)
  end

  def index
    @post_user = PostUser.new
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
      redirect_to council_posts_path(@council), notice: alert_create(Post)
    else
      render action: :new
    end
  end

  def update
    if @post.update(post_params)
      redirect_to(edit_council_post_path(@post.council, @post),
                  notice: alert_update(Post))
    else
      render action: :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to council_posts_path(@council), alert_destroy(Post)
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

  def post_user_params
    params.require(:post_user).permit(:user_id, :post_id)
  end

  def set_councils
    @councils = Council.order(title: :asc)
  end

  def set_post_user
    if params[:post_user_id].present?
      @post_user = PostUser.find(params[:post_user_id])
    else
      @post_user = PostUser.new(post_user_params)
    end
  end

  def prepare_index
    @posts = (@council.present?) ? @council.posts : Post.all
    @post_grid = initialize_grid(@posts, include: :council)
  end

  def back(council)
    council.present? ? council_posts_path(council) : posts_path
  end
end
