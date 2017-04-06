class SongsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    @songs = initialize_grid(Song.all, order: 'title', order_direction: 'asc')
  end

  def show
    Song.increment_counter(:visits, @song)
    @popular = Song.by_visits
  end

  def search
    @songs = Song.title_search(search_params[:title])
  end

  private

  def search_params
    params.require(:song).permit(:title)
  end
end
