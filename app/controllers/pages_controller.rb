# encoding:UTF-8
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
    flash[:notice] = 'Sidan skapades, success!.' if @page.save
    redirect_to @page
  end

  def update
    if @page.update(page_params)
      redirect_to @page, notice: 'Sidan uppdaterades, great!'
    else
      render action: :edit
    end
  end

  def destroy
    @page.destroy
    redirect_to pages_url
  end

  private

  def page_params
    params.fetch(:page).permit(:council_id, :url, :visible, :title)
  end
end
