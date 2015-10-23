# encoding: utf-8
class NewsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    @news = News.all_date.year(Time.zone.now)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @news.author = current_user
    if @news.save
      redirect_to news_path(@news), notice: alert_create(News)
    else
      render :new
    end
  end

  def update
    if @news.update(news_params)
      redirect_to news_path(@news), notice: alert_update(News)
    else
      render :edit
    end
  end

  def destroy
    @news.destroy!
    redirect_to news_index_path, notice: alert_destroy(News)
  end

  private

  def news_params
    params.require(:news).permit(:title, :content, :image)
  end
end
