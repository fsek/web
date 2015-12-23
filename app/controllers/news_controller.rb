# encoding: utf-8
class NewsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    @news = News.by_date
  end

  def show
    @news = News.find(params[:id])
  end
end
