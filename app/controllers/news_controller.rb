class NewsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    @news = @news.for_feed.page(params[:page])
    if params[:category].present?
      @news = category(@news)
    end
  end

  private

  def category(news)
    @category = Category.find_by_slug(params[:category])
    news.slug(params[:category])
  end
end
