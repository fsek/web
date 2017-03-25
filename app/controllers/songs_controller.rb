class SongsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    @songs = initialize_grid(Song.all)
  end

  def show
  end

  def search
    @songs = Song.title_search(search_params[:title])
  end

  private

  def search_params
    params.require(:song).permit(:title)
  end
end
