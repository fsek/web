# encoding:UTF-8
class Admin::AlbumsController < Admin::BaseController
  load_permissions_and_authorize_resource
  load_and_authorize_resource :image, through: :album

  def index
    @albums = Album.by_start.includes(:translations)
  end

  def show
    @users = User.by_firstname.members.confirmed
  end

  def new
  end

  def create
    if @album.save
      redirect_to admin_album_path(@album), notice: alert_create(Album)
    else
      render :new, status: 422
    end
  end

  def setup
    @album = Album.new
  end

  def setup_create
    service = AlbumService.new
    @album = service.create_from_event(event_params)
    unless @album.nil?
      redirect_to admin_album_path(@album), notice: alert_create(Album)
    else
      render 'setup'
    end
  end

  def destroy
    @album.destroy!
    redirect_to admin_albums_path, notice: alert_destroy(Album)
  end

  def update
    service = AlbumService.new
    if @album.update(album_params) && service.upload_images(@album)
      redirect_to(admin_album_path(@album),
                  notice: %(#alert_update(Album)} #{I18n.t('model.album.uploaded')}: #{service.uploaded}))
    else
      render :show, status: 422
    end
  end

  def destroy_images
    album = Album.find(params[:id])
    album.images.destroy_all

    redirect_to(admin_album_path(album),
                notice: alert_destroy(Image))
  end

  private

  def album_params
    params.require(:album).permit(:title_sv, :title_en, :description_sv, :description_en,
                                  :location, :start_date, :end_date,
                                  :photographer_user, :photographer_name, :event_id,
                                  image_upload: [])
  end

  def event_params
    params.require(:album).permit(:event_id)
  end
end
