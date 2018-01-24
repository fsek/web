class Api::SongsController < Api::BaseController
  load_permissions_and_authorize_resource

  def index
    @songs = Song.all
    render json: @songs,
    each_serializer: Api::SongSerializer::Multiple # Returns id and title
  end

  def show
    @song = Song.find(params[:id])
    Song.increment_counter(:visits, @song)
    render json: @song,
    serializer: Api::SongSerializer::Single # Returns all relevant fields
  end
end
