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
    @year = params[:year] || Time.zone.now.year
    @all_years = Album.unique_years - [@year.to_i]
  end

  def load_albums
    @albums = Album.gallery(Time.zone.local(@year, 3))
  end

  def load_policy
    constant = Constant.find_by(name: 'gallery_policy')
    if constant.present?
      @policy = Document.find_by(id: constant.value)
    end
  end
end
