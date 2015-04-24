# encoding:UTF-8
class PostsController < ApplicationController
<<<<<<< HEAD
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
=======
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
>>>>>>> 699d7174360268a9fd59e6c5e822da01cde30e0e
    else
      flash[:alert] = %(Tilldelningen gick inte: #{@post.errors.full_messages})
    end
<<<<<<< HEAD
    @post_grid = initialize_grid(@posts)
  end

=======
    redirect_to back
  end

  def index
    @posts = (@council.present?) ? @council.posts : Post.all
    @post_grid = initialize_grid(@posts)
  end

>>>>>>> 699d7174360268a9fd59e6c5e822da01cde30e0e
  def new
    @post = @council.posts.build
  end

  def edit
    @councils = Council.order(title: :asc)
  end

  def create
<<<<<<< HEAD
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
=======
    @post = @council.posts.build(post_params)
    if @post.save
      redirect_to council_posts_path(@council), notice: alert_create_resource(Post)
    else
      render action: :new
>>>>>>> 699d7174360268a9fd59e6c5e822da01cde30e0e
    end
  end

  def update
<<<<<<< HEAD
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
=======
    if @post.update(post_params)
      redirect_to edit_council_post_path(@post.council, @post), notice: alert_update_resource(Post)
    else
      render action: :edit
>>>>>>> 699d7174360268a9fd59e6c5e822da01cde30e0e
    end
  end

  def destroy
<<<<<<< HEAD
    @post.users.clear
    @post.destroy
    redirect_to council_posts_path(@council)
=======
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
>>>>>>> 699d7174360268a9fd59e6c5e822da01cde30e0e
  end

  def display
  end

  def collapse
  end

  private

  def post_params
    params.require(:post).permit(:title, :limit, :recLimit,
<<<<<<< HEAD
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
=======
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
>>>>>>> 699d7174360268a9fd59e6c5e822da01cde30e0e
  end
end
