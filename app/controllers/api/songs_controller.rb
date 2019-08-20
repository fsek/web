class Api::SongsController < Api::BaseController
  load_permissions_and_authorize_resource

  def index
    @songs = Song.order(title: :asc)
    render json: @songs,
    each_serializer: Api::SongSerializer::Index # Returns id, title and author
  end

  def show
    @song = Song.find(params[:id])
    Song.increment_counter(:visits, @song)
    render json: @song,
    serializer: Api::SongSerializer::Show # Returns all relevant fields
  end

  def chants
    @chants = SongCategory.where(slug: 'chants').take.songs.order(author: :asc)
    render json: @chants,
    each_serializer: Api::SongSerializer::Index # Returns id, title and author
  end
end
