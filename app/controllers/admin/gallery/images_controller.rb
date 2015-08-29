# encoding:UTF-8
class Admin::Gallery::ImagesController < ApplicationController
  before_action :authorize
  load_permissions_and_authorize_resource :album, parent: true
  load_and_authorize_resource :image, through: :album

  def index
    @images = @album.images.order('foto_file_name asc')
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @image.save
      redirect_to admin_image_path(@image), notice: alert_create(Image)
    else
      render :new
    end
  end

  def update
    if @image.update(image_params)
      redirect_to admin_image_path(@image), notice: alert_update(Image)
    else
      render :edit
    end
  end

  def destroy
    @image.destroy!
      redirect_to edit_album_path(@album), notice: alert_destroy(Image)
  end

  private

  def authorize
    authorize! :manage, Image
  end

  def image_params
    params.require(:image).permit(:file, :album_id)
  end
end
