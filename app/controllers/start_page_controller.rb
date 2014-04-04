class StartPageController < ApplicationController
  include TheRole::Controller
layout "startsida"
skip_before_filter :authenticate_user!
before_action :set_news, only: [:show, :edit, :update, :destroy]

  def startsida
    add_breadcrumb 'Hem', :start_path
    @news = News.all
  end
end
