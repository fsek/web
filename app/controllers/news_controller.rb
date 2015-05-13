# encoding: utf-8

class NewsController < ApplicationController
  load_and_authorize_resource

  def index
    @news = News.all_date
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @news.user = current_user
    @news.save!
    redirect_to news_path(@news)
  end

  def update
    @news.update! news_params
    redirect_to news_path(@news)
  end

  def destroy
    @news.destroy!
    redirect_to news_index_path
  end

  private

  def news_params
    params.require(:news).permit(:title, :content, :image)
  end
end
