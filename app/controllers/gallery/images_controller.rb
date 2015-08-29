# encoding:UTF-8
class Gallery::ImagesController < ApplicationController
  load_permissions_and_authorize_resource :album, parent: true
  load_and_authorize_resource :image, through: :album
  before_action :set_image, only: [:show, :edit, :update, :destroy]
  before_action :set_album, only: [:index,:new,:create, :show, :edit, :update, :destroy,:edit_multiple,:update_multiple]

  def index
    @images = @album.images.order('foto_file_name asc')
  end

  def show
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def image_params
    params.fetch(:image).permit(:foto,:album_id,:subcategory_id)
  end
end
