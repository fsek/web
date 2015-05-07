class ShortLinksController < ApplicationController
  load_permissions_and_authorize_resource :except => [ :go, :check ]

  def go
    redirect_to ShortLink.lookup(params[:link]).target, :status => 301
  end

  def index
    @short_link = ShortLink.new
  end

  def check
    if ShortLink.where('link = ?', params[:link]).exists?
      render :nothing => true, :status => :no_content
    else
      render :nothing => true, :status => :not_found
    end
  end

  def create
    @short_link = ShortLink.find_or_initialize_by(
      :link => short_link_params[:link]
    )
    @short_link.update! short_link_params

    flash[:notice] = 'Snabblänken sparades'
    redirect_to ShortLink
  end

  def destroy
    ShortLink.find(params[:id]).destroy!

    flash[:notice] = 'Snabblänken togs bort'
    redirect_to ShortLink
  end

  private
  def short_link_params
    params.require(:short_link).permit(
      :link, :target,
    )
  end
end
