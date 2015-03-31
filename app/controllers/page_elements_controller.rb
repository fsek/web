# encoding:UTF-8
class PageElementsController < ApplicationController
  before_action :load_permissions
  load_and_authorize_resource :page, parent: true, find_by: :url
  load_and_authorize_resource :page_element, through: :page

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @page_element.save
      redirect_to edit_page_page_element_path(@page, @page_element), notice: 'Elementet skapades'
    else
      render action: :new
    end
  end

  def update
    if @page_element.update(page_element_params)
      redirect_to edit_page_page_element_path(@page, @page_element), notice: 'Elementet uppdaterades.'
    else
      render action: :edit
    end
  end

  def destroy
    @page_element.destroy
    redirect_to @page
  end

  private

  def page_element_params
    params.fetch(:page_element).permit(:page_id, :displayIndex, :sidebar, :visible, :text, :headline, :border, :name, :pictureR, :picture)
  end
end
