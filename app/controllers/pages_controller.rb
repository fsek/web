# encoding: UTF-8
class PagesController < ApplicationController
  load_permissions_and_authorize_resource find_by: :url

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @page.save
      redirect_to page_path(@page), notice: alert_create(Page)
    else
      render :new
    end
  end

  def update
    if @page.update(page_params)
      redirect_to edit_page_path(@page), notice: alert_update(Page)
    else
      render :edit
    end
  end

  def destroy
    @page.destroy!
    redirect_to pages_url
  end

  private

  def page_params
    params.require(:page).permit(:council_id, :url, :visible, :title, :namespace)
  end
end
