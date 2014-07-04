class StartPageController < ApplicationController
  include TheRole::Controller

  skip_before_filter :authenticate_user!
  before_action :set_news, only: [:show, :edit, :update, :destroy]

  def index
    @news = News.all
  end
end
