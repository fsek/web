class Admin::SongCategoriesController < Admin::BaseController
  load_permissions_and_authorize_resource

  def new
    @song_categories = SongCategory.new
  end

  def index
    @song_categories = initialize_grid(SongCategory.all)
  end

  def edit
    @song_category = SongCategory.find(params[:id])
  end

  def create
    @song_category = SongCategory.new(song_category_params)
    if @song_category.save
      redirect_to admin_song_categories_path, notice: alert_create(SongCategory)
    else
      render :new, status: 422
    end
  end

  def update
    @song_category = SongCategory.find(params[:id])
    if @song_category.update(song_category_params)
      redirect_to admin_song_categories_path, notice: alert_update(SongCategory)
    else
      render :edit, status: 422
    end
  end

#One can only destroy if song_category has no songs
  def destroy
    song_category = SongCategory.find(params[:id])
    song_category.destroy!
    redirect_to admin_song_categories_path, notice: alert_destroy(SongCategory)
  end

  private

  def song_category_params
    params.require(:song_category).permit(:name)
  end
end
