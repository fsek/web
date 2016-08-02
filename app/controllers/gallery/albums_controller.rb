# encoding:UTF-8
class Gallery::AlbumsController < ApplicationController
  load_permissions_and_authorize_resource

  def show
    @album = Album.include_for_gallery.includes(:photographers).find(params[:id])
    @policy = Document.find_by(slug: 'gallery_policy')
    @start = params.fetch(:start, 0).to_i
  end
end
