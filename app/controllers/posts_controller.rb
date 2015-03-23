# encoding:UTF-8
class PostsController < ApplicationController
  before_action :authenticate
  before_action :set_council
  before_action :set_councils
  before_action :set_edit
  before_action :set_post, only: [:show, :edit, :update, :destroy, :remove_user, :add_user]

  def remove_user
    user = User.find_by_id(params[:user_id])
    @post.users.delete(user)
    redirect_to council_posts_path(@council), notice: %(#{user.name} har inte längre posten #{@post.title}.)
  end

  def add_user
    user = User.find_by(username: params[:username])
    if user.nil?
      redirect_to council_posts_path(@council), alert: 'Hittade ingen användare med det användarnamnet.'
    elsif user.posts.include?(@post)
      redirect_to council_posts_path(@council), alert: %(#{user.name} har redan posten #{@post.title} .)
    elsif (@post.limit.present?) && (@post.users.size >= @post.limit)
      redirect_to council_posts_path(@council), alert: %(#{@post.title}har sitt maxantal.)
    else
      @post.users << user
      redirect_to council_posts_path(@council), notice: %(#{user.name} tilldelades posten #{@post.title} .)
      if (user.first_post == nil)
        user.update(first_post: @post.id)
      end
    end
  end

  def index
    if (@council)
      @posts = @council.posts
    else
      @posts = Post.all
    end
    @post_grid = initialize_grid(@posts)
  end

  def new
    @post = @council.posts.build
    @councils = Council.order(title: :asc)
  end

  def edit
    @councils = Council.order(title: :asc)
  end

  def create
    @councils = Council.order(title: :asc)
    @post = @council.posts.build(post_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to council_posts_path(@council), notice: 'Posten skapades!' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @posts.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        @council2 = Council.find_by_id(params[:post][:council])
        if (@council2) && (@council2.equal?(@council) == false)
          @council2.posts << @post
          @council = @council2
        end
        format.html { redirect_to edit_council_post_path(@council, @post), notice: 'Posten uppdaterades!' }
        format.json { head :no_content }
      else
        @councils = Council.order(title: :asc)
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.users.clear
    @post.destroy
    redirect_to council_posts_path(@council)
  end

  private

  def post_params
    params.require(:post).permit(:title, :limit, :recLimit,
                                 :description, :elected_by, :elected_at, :styrelse,
                                 :car_rent, :council_id)
  end

  def authenticate
    flash[:error] = t('the_role.access_denied')
    redirect_to(:back) unless (current_user) && (current_user.moderator?(:poster))
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  def set_edit
    if (current_user) && (current_user.moderator?(:poster))
      @edit = true
    end
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def set_council
    @council = Council.find_by_url(params[:council_id])
  end

  def set_councils
    @councils = Council.order(title: :asc)
  end
end
