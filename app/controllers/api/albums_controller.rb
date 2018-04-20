class Api::AlbumsController < Api::BaseController
  load_permissions_then_authorize_resource

  def show
    @album = Album.include_for_gallery.includes(:photographers).find(params[:id])

    render json: @album, serializer: Api::AlbumSerializer::Show
  end
end
