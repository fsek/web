class Api::SongsController < Api::BaseController
  load_permissions_and_authorize_resource

  def index
    @songs = Song.order(title: :asc)
    render json: @songs,
    each_serializer: Api::SongSerializer::Index
  end

  def show
    @song = Song.find(params[:id])
    Song.increment_counter(:visits, @song)
    render json: @song,
    serializer: Api::SongSerializer::Show
  end
end
