# encoding:UTF-8
class Gallery::AlbumsController < ApplicationController
  load_permissions_and_authorize_resource

  def show
    if params[:start].present?
      @start = params[:start]
    elsif params[:image].present?
      @start = @album.images.find_index(Image.find(params[:image]))
    end
  end
end
