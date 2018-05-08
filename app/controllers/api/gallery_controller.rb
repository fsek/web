class Api::GalleryController < Api::BaseController
  load_permissions_then_authorize_resource class: false

  def index
    @albums = Album.include_for_gallery.gallery(Time.zone.local(Time.zone.now.year, 3))

    render json: @albums, each_serializer: Api::AlbumSerializer::Index
  end

  def show
    @albums = Album.include_for_gallery.gallery(Time.zone.local(params[:id], 3))

    render json: @albums, each_serializer: Api::AlbumSerializer::Index
  end
end
