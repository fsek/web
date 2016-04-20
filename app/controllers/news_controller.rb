# encoding: utf-8
class NewsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    @news = @news.by_date
    if params[:category].present?
      @news = category(@news)
    end
  end

  def show
    @news = News.find(params[:id])
  end

  private

  def category(news)
    @category = Category.find_by_slug(params[:category])
    news.joins(:categories).where(categories: { slug: params[:category] })
  end
end
