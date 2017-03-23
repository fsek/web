class SongsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    @songs = initialize_grid(Song.all)
  end

  def show
    @songs = initialize_grid(Song.all)
  end
end
