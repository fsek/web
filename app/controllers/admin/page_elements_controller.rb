# encoding:UTF-8
class Admin::PageElementsController < Admin::BaseController
  before_action :load_permissions
  load_and_authorize_resource :page, parent: true, find_by: :url
  load_and_authorize_resource :page_element, through: :page

  def index
    page = Page.includes(:page_elements).find_by!(url: params[:page_id])
    @element_grid = initialize_grid(page.page_elements)
  end

  def new
    page = Page.includes(:page_elements).find_by!(url: params[:page_id])
    @page_element = page.page_elements.build
  end

  def edit
    page = Page.includes(:page_elements).find_by!(url: params[:page_id])
    @page_element = page.page_elements.find(params[:id])
  end

  def create
    page = Page.find_by!(url: params[:page_id])
    @page_element = page.page_elements.build(page_element_params)
    if @page_element.save
      redirect_to(edit_admin_page_page_element_path(page, @page_element),
                  notice: alert_create(PageElement))
    else
      render :new, status: 422
    end
  end

  def update
    page = Page.find_by!(url: params[:page_id])
    @page_element = page.page_elements.find(params[:id])

    if @page_element.update(page_element_params)
      redirect_to(edit_admin_page_page_element_path(page, @page_element),
                  notice: alert_update(PageElement))
    else
      render :edit, status: 422
    end
  end

  def destroy
    page = Page.find_by!(url: params[:page_id])
    page_element = page.page_elements.find(params[:id])
    page_element.destroy!
    redirect_to edit_admin_page_path(page), notice: alert_destroy(PageElement)
  end

  private

  def page_element_params
    params.require(:page_element).permit(:index, :sidebar, :visible, :text_sv,
                                         :text_en, :headline_sv, :headline_en,
                                         :element_type, :page_image_id)
  end
end
