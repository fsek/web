class BlogPostsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    @blog_posts = category(BlogPost.by_created.include_for_index.page(params[:page]))
  end

  def show
    @other_blog_posts = BlogPost.by_created.include_for_index.other(@blog_post)
  end

  private

  def category(blog_post)
    @category = Category.find_by_slug(params[:category])
    params[:category].present? ? blog_post.slug(params[:category]) : blog_post
  end
end
