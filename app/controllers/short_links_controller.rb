class ShortLinksController < ApplicationController

  def go
    redirect_to ShortLink.lookup(params[:link]).target, status: 301
  end

  def check
    if ShortLink.where('link = ?', params[:link]).exists?
      render nothing: true, status: :no_content
    else
      render nothing: true, status: :not_found
    end
  end

  private

  def short_link_params
    params.require(:short_link).permit(:link, :target)
  end
end
