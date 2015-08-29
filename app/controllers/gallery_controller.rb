# encoding: UTF-8
class GalleryController < ApplicationController
  #load_permissions_and_authorize_resource :calendar

  def index
    @albums = Album.all
  end
end

