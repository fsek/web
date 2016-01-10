# encoding: utf-8
class Admin::NewsController < ApplicationController
  before_action :authorize

  def index
    @news_grid = initialize_grid(News, include: :user,
                                       order: 'news.created_at',
                                       order_direction: :desc)
  end

  def new
    @news = News.new
  end

  def edit
    @news = News.find(params[:id])
  end

  def create
    @news = News.new(news_params)
    @news.user = current_user
    if @news.save
      redirect_to news_path(@news), notice: alert_create(News)
    else
      render :new, status: 422
    end
  end

  def update
    @news = News.find(params[:id])
    if @news.update(news_params)
      redirect_to news_path(@news), notice: alert_update(News)
    else
      render :edit, status: 422
    end
  end

  def destroy
    @news = News.find(params[:id])
    @news.destroy!
    redirect_to admin_news_index_path, notice: alert_destroy(News)
  end

  private

  def authorize
    can?(:manage, News)
  end

  def news_params
    params.require(:news).permit(:title, :content, :image, :url, :remove_image)
  end
end
