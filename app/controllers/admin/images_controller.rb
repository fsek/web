# encoding:UTF-8
class Admin::ImagesController < Admin::BaseController
  load_permissions_and_authorize_resource
  load_and_authorize_resource :album

  def download
    if @image.file
      send_file(@image.file.path, filename: @image.filename, type: 'image/jpg',
                                  x_sendfile: true)
    end
  end

  def reprocess
    @image.file.recreate_versions!
    if @image.save
      redirect_to(admin_album_image_path(@album, @image))
    else
      render(:show, notice: I18n.t('model.image.cannot_save_reprocess'))
    end
  end

  def destroy
    @image.destroy!
    redirect_to admin_album_path(@album), notice: alert_destroy(Image)
  end
end
