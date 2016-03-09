# encoding: UTF-8
class PagesController < ApplicationController
  load_permissions_and_authorize_resource find_by: :url

  def show
    @page = set_page
  end

  private

  def set_page
    if current_user.try(:member?)
      Page.includes(:page_elements).
        visible.
        find_by!(url: params[:id])
    else
      Page.includes(:page_elements).
        visible.
        publik.
        find_by!(url: params[:id])
    end
  end
end
