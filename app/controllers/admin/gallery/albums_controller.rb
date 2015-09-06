# encoding:UTF-8
class Admin::Gallery::AlbumsController < ApplicationController
  before_action :authorize
  load_permissions_and_authorize_resource
  load_and_authorize_resource :image, through: :album

  def index
    @albums = Album.order('start_date asc')
  end

  def edit
    @users = User.all_firstname
  end

  def new
    @users = User.all_firstname
  end

  def create
    if @album.save
      redirect_to admin_gallery_album_path(@album), notice: alert_create(Album)
    else
      render action: :new
    end
  end

  def destroy
    @album.destroy
    redirect_to admin_gallery_albums_path, notice: alert_destroy(Album)
  end

  def update
    @users = User.all_firstname
    if @album.update(album_params)
      if album_params[:images_upload].present?
        album_params[:images_upload].each do |f|
          @album.images.create(file: f, photographer_id: album_params[:images_photographer])
        end
      end
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
                                  :images_photographer, images_upload: [])
  end
end
