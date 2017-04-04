class Admin::SongsController < Admin::BaseController
  load_permissions_and_authorize_resource

  def new
    @song = Song.new
  end

  def index
    @songs = initialize_grid(Song.all)
  end

  def edit
    @song = Song.find(params[:id])
  end

  def create
    @song = Song.new(song_params)
    if @song.save
      redirect_to admin_songs_path, notice: alert_create(Song)
    else
      render :new, status: 422
    end
  end

  def update
    @song = Song.find(params[:id])
    if @song.update(song_params)
      redirect_to admin_songs_path, notice: alert_update(Song)
    else
      render :edit, status: 422
    end
  end

  def song_params
    params.require(:song).permit(:title, :author, :melody, :category, :content)
  end

  def destroy
    song = Song.find(params[:id])
    song.destroy!

    redirect_to admin_songs_path, notice: alert_destroy(Song)
  end
end
