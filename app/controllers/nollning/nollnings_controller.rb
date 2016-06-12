class Nollning::NollningsController < ApplicationController
  load_permissions_then_authorize_resource class: false

  def index
    @constant = Constant.find_by_name('nollning-video')
    @news = News.include_for_feed.slug(:nollning).by_date.limit(5)
  end

  def matrix
    @events = Event.includes(:translations).slug(:nollning)
  end

  def modal
    @date = Date.strptime(%({#{params[:date]}}), "{%Y-%m-%d}")
    @events = Event.includes(:translations).slug(:nollning).from_date(@date)
    respond_to do |format|
      format.html
      format.js
    end
  end
end
