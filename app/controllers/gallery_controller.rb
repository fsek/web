# encoding: UTF-8
class GalleryController < ApplicationController
  load_permissions_then_authorize_resource class: false
  before_action :set_year
  before_action :load_albums
  before_action :load_policy

  def index
  end

  private

  # If year != current_year the variable is set
  def set_year
    @year = params[:year]
    @years = Album.select('distinct year(start_date)').pluck('year(start_date)')

    if @year.present?
      @years = @years - [@year]
    else
      @years = @years - [Time.zone.now.year.to_i]
    end
  end

  def load_albums
    if @year.present?
      @albums = Album.gallery(Time.zone.local(@year))
    else
      @albums = Album.gallery(Time.zone.now)
    end
  end

  def load_policy
    constant = Constant.find_by(name: 'gallery_policy')
    if constant.present?
      @policy = Document.find_by(id: constant.value)
    end
  end
end
