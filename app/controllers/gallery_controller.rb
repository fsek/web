class GalleryController < ApplicationController
  load_permissions_then_authorize_resource class: false

  def index
    @year = params[:year] || Time.zone.now.year
    @all_years = Album.unique_years - [@year.to_i]

    @albums = album(Album.include_for_gallery.gallery(Time.zone.local(@year, 3)))

    @policy = Document.find_by(slug: :gallery_policy)
  end

  private

  def album(albums)
   current_user.try(:summerchild?) ? albums.summer : albums
  end
end
