class Api::NewsController < Api::BaseController
  load_permissions_and_authorize_resource

  def index
    @news = News.for_feed.unpinned.page(params[:page]).per(5)
    render json: @news, meta: pagination_meta(@news)
  end
end
