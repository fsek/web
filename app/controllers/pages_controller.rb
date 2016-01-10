# encoding: UTF-8
class PagesController < ApplicationController
  load_permissions_and_authorize_resource find_by: :url

  def index
    @pages = Page.all
  end

  def show
    @page = Page.find_by!(url: params[:id])
  end

  def new
    @page = Page.new
  end

  def edit
    @page = Page.find_by!(url: params[:id])
  end

  def create
    @page = Page.new(page_params)
    if @page.save
      redirect_to page_path(@page), notice: alert_create(Page)
    else
      render :new, status: 422
    end
  end

  def update
    @page = Page.find_by!(url: params[:id])
    if @page.update(page_params)
      redirect_to edit_page_path(@page), notice: alert_update(Page)
    else
      render :edit, status: 422
    end
  end

  def destroy
    @page = Page.find_by!(url: params[:id])
    @page.destroy!
    redirect_to pages_url
  end

  private

  def page_params
    params.require(:page).permit(:council_id, :url, :visible, :title, :namespace)
  end
end
