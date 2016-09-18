class GalleryController < ApplicationController
  load_permissions_then_authorize_resource class: false

  def index
    @year = params[:year] || Time.zone.now.year
    @all_years = Album.unique_years - [@year.to_i]

    @albums = Album.include_for_gallery.gallery(Time.zone.local(@year, 3))

    @policy = Document.find_by(slug: :gallery_policy)
  end
end
