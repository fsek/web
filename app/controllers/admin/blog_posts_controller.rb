class Admin::BlogPostsController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @post_grid = initialize_grid(BlogPost,
                                 include: :user,
                                 locale: :sv,
                                 order: :created_at)
  end

  def new
    @categories = Category.by_title
  end

  def create
    @blog_post.user = current_user
    if @blog_post.save
      redirect_to(edit_admin_blog_post_path(@blog_post), notice: alert_create(BlogPost))
    else
      render :new, status: 422
    end
  end

  def edit
  end

  def update
    if @blog_post.update(blog_post_params)
      redirect_to(edit_admin_blog_post_path(@blog_post), notice: alert_update(BlogPost))
    else
      render :edit, status: 422
    end
  end

  def destroy
    @blog_post.destroy!
    redirect_to(admin_blog_posts_path, notice: alert_destroy(BlogPost))
  end

  private

  def blog_post_params
    params.require(:blog_post).permit(:title_sv, :title_en,
                                      :content_sv, :content_en,
                                      :preamble_sv, :preamble_en,
                                      :cover_image, :remove_cover_image,
                                      category_ids: [])
  end
end
