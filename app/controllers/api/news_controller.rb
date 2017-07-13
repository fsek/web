class Api::NewsController < Api::BaseController
  load_permissions_and_authorize_resource

  def index
    @pinned = News.for_feed.pinned
    @unpinned = News.for_feed.unpinned.page(params[:page])

    render json: { pinned: serialize(@pinned),
                   unpinned: serialize(@unpinned, meta: pagination_meta(@unpinned)) }
  end

  private

  def serialize(news, meta: nil)
    options = { meta: meta, namespace: :Api }
    ActiveModelSerializers::SerializableResource.new(news, options)
  end
end
