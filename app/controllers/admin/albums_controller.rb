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

  def destroy
    @album.destroy!
    redirect_to admin_albums_path, notice: alert_destroy(Album)
  end

  def update
    @users = User.by_firstname
    service = AlbumService.new
    if @album.update(album_params) && service.upload_images(@album)
      redirect_to(admin_album_path(@album),
                  notice: %(#{alert_update(Album)} #{I18n.t('model.album.uploaded')}: #{service.uploaded}))
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
                                  :photographer_user, :photographer_name,
                                  image_upload: [])
  end
end
