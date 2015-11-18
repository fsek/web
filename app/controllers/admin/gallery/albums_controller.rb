# encoding:UTF-8
class Admin::Gallery::AlbumsController < ApplicationController
  before_action :authorize
  load_permissions_and_authorize_resource
  load_and_authorize_resource :image, through: :album
  before_action :load_users, only: [:edit, :new, :update]

  def index
    @albums = Album.order('start_date asc')
  end

  def edit
  end

  def new
  end

  def create
    if @album.save
      redirect_to edit_admin_gallery_album_path(@album), notice: alert_create(Album)
    else
      render action: :new
    end
  end

  def destroy
    @album.destroy
    redirect_to admin_gallery_albums_path, notice: alert_destroy(Album)
  end

  def update
    if @album.update(album_params) && AlbumService.upload_images(@album)
      redirect_to edit_admin_gallery_album_path(@album), notice: alert_update(Album)
    else
      render action: :edit
    end
  end

  private

  def authorize
    authorize! :manage, Album
  end

  def album_params
    params.require(:album).permit(:title, :description, :location,
                                  :public, :start_date, :end_date,
                                  :photographer_user, :photographer_name,
                                  image_upload: [])
  end

  def load_users
    @users = User.all_firstname
  end
end
