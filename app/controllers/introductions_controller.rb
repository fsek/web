class IntroductionsController < ApplicationController
  before_action :set_introduction, only: [:index, :matrix]
  load_permissions_then_authorize_resource(find_by: :slug)

  def index
    @constant = Constant.find_by_name('nollning-video')
    @news = News.include_for_feed.slug(:nollning).by_date.limit(5)
  end

  def show
    @introduction = Introduction.find_by_slug!(params[:id])
    set_meta_tags(no_index: true)
    render :index
  end

  def archive
    @introductions = Introduction.by_start
  end

  def matrix
  end

  def modal
    @introduction = Introduction.find_by_slug!(params[:id])
    @date = date
    @events = @introduction.events.includes(:translations).from_date(@date)
    respond_to do |format|
      format.html { render :matrix, status: 303 }
      format.js
    end
  end

  private

  def set_introduction
    @introduction = Introduction.current

    if @introduction.nil?
      @introductions = Introduction.by_start
      render :archive, status: 404
    end
  end

  def date
    begin
      Date.strptime(%({#{params[:date]}}), '{%Y-%m-%d}')
    rescue
      Date.today
    end
  end
end
