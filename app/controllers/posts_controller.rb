# encoding: UTF-8
class PostsController < ApplicationController
  load_permissions_and_authorize_resource
  load_and_authorize_resource :council, parent: true, find_by: :url

  def add_user
    council = Council.find_by_url!(params[:council_id])
    @post_view = PostView.new(council: council,
                              post_user: PostUser.new(post_user_params),
                              users: User.all_firstname)
    @post_view = set_grids(@post_view)

    if PostUserService.create(@post_view.post_user)
      redirect_to council_posts_path(@post_view.council),
                  notice: I18n.t('post.added',
                                 u: @post_view.post_user.user,
                                 p: @post_view.post_user.post)
    else
      render :index
    end
  end

  def remove_user
    post_user = PostUser.find(params[:post_user_id])
    @status = I18n.t('post.user_removed',
                     u: post_user.user,
                     p: post_user.post)
    @id = params[:post_user_id]

    @state = post_user.destroy
  end

  def index
    council = Council.find_by_url!(params[:council_id])
    @post_view = PostView.new(council: council,
                              post_user: PostUser.new,
                              users: User.all_firstname)
    @post_view.post_grid = initialize_grid(council.posts,
                                           order: :title,
                                           name: 'posts')
    @post_view.post_user_grid = initialize_grid(council.post_users,
                                                include: [:post, :user],
                                                name: 'post_users')
  end

  def new
    @council = Council.find_by_url!(params[:council_id])
    @post = @council.posts.build
  end

  def edit
    @councils = Council.order(title: :asc)
  end

  def create
    @council = Council.find_by_url!(params[:council_id])
    @post = @council.posts.build(post_params)
    if @post.save
      redirect_to council_posts_path(@council), notice: alert_create(Post)
    else
      render :new, status: 422
    end
  end

  def update
    @council = Council.find_by_url!(params[:council_id])
    @post = @council.posts.find(params[:id])

    if @post.update(post_params)
      redirect_to(edit_council_post_path(@council, @post),
                  notice: alert_update(Post))
    else
      render :edit, status: 422
    end
  end

  def destroy
    council = Council.find_by_url!(params[:council_id])
    post = council.posts.find(params[:id])

    post.destroy!
    redirect_to council_posts_path(council), alert_destroy(Post)
  end

  def display
    @election = Election.current
  end

  def collapse
  end

  private

  def set_grids(post_view)
    post_view.post_grid = initialize_grid(post_view.council.posts,
                                          order: :title,
                                          name: 'posts')
    post_view.post_user_grid = initialize_grid(post_view.council.post_users,
                                               include: [:post, :user],
                                               name: 'post_users')

    post_view
  end

  def post_params
    params.require(:post).permit(:title, :limit, :rec_limit,
                                 :description, :elected_by, :semester,
                                 :board, :car_rent, :council_id)
  end

  def post_user_params
    params.require(:post_user).permit(:user_id, :post_id)
  end
end
