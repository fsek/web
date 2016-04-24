class Nollning::NollningsController < ApplicationController
  load_permissions_then_authorize_resource class: false

  def index
    @constant = Constant.find_by_name('nollning-video')
    @news = News.by_date.joins(:categories).where(categories: { slug: :nollning }).limit(5)
  end

  def matrix
    @events = Event.nollning
  end

  def modal
    @date = Date.strptime(%({#{params[:date]}}), "{%Y-%m-%d}")
    @events = Event.from_date(@date)
    respond_to do |format|
      format.html
      format.js
    end
  end
end
