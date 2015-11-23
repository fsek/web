# encoding:UTF-8
class Admin::Gallery::ImagesController < ApplicationController
  before_action :authorize
  load_permissions_and_authorize_resource
  load_and_authorize_resource :album

  def download
    if @image.file
      send_file(@image.file.path, filename: @image.filename, type: 'image/jpg',
                                  x_sendfile: true)
    end
  end

  def destroy
    @image.destroy
    redirect_to admin_gallery_album_path(@album), notice: alert_destroy(Image)
  end

  private

  def authorize
    authorize! :manage, Album
  end
end
