class Api::StartController < Api::BaseController
  authorize_resource class: false

  def index
    @pinned = News.for_feed.pinned
    @unpinned = News.for_feed.unpinned.page(1).per(5)
    @events = Event.includes(:translations).stream

    render json: { pinned: serialize(@pinned),
                   unpinned: serialize(@unpinned, meta: pagination_meta(@unpinned)),
                   events: serialize(@events, namespace: '') }
  end

  private

  def serialize(collection, namespace: :Api, meta: nil)
    options = { meta: meta, namespace: namespace }
    ActiveModelSerializers::SerializableResource.new(collection, options)
  end
end
