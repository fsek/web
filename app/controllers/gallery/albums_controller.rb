# encoding:UTF-8
class Gallery::AlbumsController < ApplicationController
  load_permissions_and_authorize_resource
  load_and_authorize_resource :image, through: :album

  def show
    if (@album.images)
      @images = @album.images.order('foto_file_name asc')
    else
      @images = nil
    end
  end
end
