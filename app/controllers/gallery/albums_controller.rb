# encoding:UTF-8
class Gallery::AlbumsController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :load_policy

  def show
    if params[:start].present?
      @start = params[:start]
    elsif params[:image].present?
      @start = @album.images.find_index(Image.find(params[:image]))
    end
  end

  private

  def load_policy
    constant = Constant.find_by(name: 'gallery_policy')
    if constant.present?
      @policy = Document.find_by(id: constant.value)
    end
  end
end
