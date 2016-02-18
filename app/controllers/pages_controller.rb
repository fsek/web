# encoding: UTF-8
class PagesController < ApplicationController
  load_permissions_and_authorize_resource find_by: :url

  def show
    @page = Page.includes(:page_elements).find_by!(url: params[:id])
  end
end
