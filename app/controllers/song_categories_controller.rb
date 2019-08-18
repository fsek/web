class SongCategoriesController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    @song_categories = initialize_grid(SongCategory.all, order: 'name', order_direction: 'asc')
  end

  def show #???
    Song.increment_counter(:visits, @song)
    @popular = Song.by_visits
  end

  def search
    @song_categories = SongCategory.title_search(search_params[:name])
  end

  private

  def search_params
    params.require(:song_category).permit(:name)
  end
end
