# encoding:UTF-8
class PostsController < ApplicationController
  load_permissions_and_authorize_resource
  load_and_authorize_resource :council, parent: true, find_by: :url
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
    @post_permissions = @post.permissions.collect! { |p| p.id }
  end

  def edit
    @post_permissions = @post.permissions.collect! { |p| p.id }
  end

  def create
    @post = @council.posts.build(post_params)
    if @post.save
      redirect_to council_posts_path(@council), notice: 'Posten skapades!'
    else
      render action: 'new'
    end
  end

  def update
    @post.attributes = post_params
    @post.permissions = []
    @post.set_permissions(params[:permissions]) if params[:permissions]
    if @post.save
      redirect_to edit_council_post_path(@post.council, @post), notice: 'Posten uppdaterades!'
    else
      render action: 'edit'
    end
  end

  def destroy
    @post.destroy
    redirect_to council_posts_path(@council)
  end

  def display
  end

  def collapse
  end

  private

  def post_params
    params.require(:post).permit(:title, :limit, :recLimit,
                                 :description, :elected_by, :elected_at,
                                 :styrelse, :car_rent, :council_id, :permissions)
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
