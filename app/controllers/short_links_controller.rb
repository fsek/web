class ShortLinksController < ApplicationController

  def go
    redirect_to ShortLink.lookup(params[:link]).target, status: 301
  end

  def check
    if ShortLink.where('link = ?', params[:link]).exists?
      head :no_content
    else
      head :not_found
    end
  end

  private

  def short_link_params
    params.require(:short_link).permit(:link, :target)
  end
end
