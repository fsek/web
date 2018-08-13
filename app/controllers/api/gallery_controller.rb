class Api::GalleryController < Api::BaseController
  load_permissions_then_authorize_resource class: false

  def index
    @year = params[:year] || Album.include_for_gallery.order('start_date').last.start_date.year

    @albums = Album.include_for_gallery.gallery(Time.zone.local(@year, 3))

    render json: @albums, each_serializer: Api::AlbumSerializer::Index
  end
end
