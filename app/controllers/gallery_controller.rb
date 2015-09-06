# encoding: UTF-8
class GalleryController < ApplicationController
  load_permissions_then_authorize_resource class: false

  def index
    @albums = Album.none

    if params[:year].present?
      @year = params[:year]
      @albums = Album.gallery(Time.new(@year))
    else
      @albums = Album.gallery(Time.zone.now)
    end

    if not can? :show, Album.new(public: false)
      @albums = @albums.publik
    end

    @years = Album.select('distinct year(start_date) as year')
  end
end

