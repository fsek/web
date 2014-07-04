# encoding:UTF-8
class StartPageController < ApplicationController
  include TheRole::Controller

  skip_before_filter :authenticate_user!  

  def index
    @news = News.all
  end
end
