class Admin::PagesController < Admin::BaseController
  load_permissions_and_authorize_resource find_by: :url

  def index
    @page_grid = initialize_grid(Page, include: [:translations, council: :translations])
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
      redirect_to edit_admin_page_path(@page), notice: alert_create(Page)
    else
      render :new, status: 422
    end
  end

  def update
    @page = Page.find_by!(url: params[:id])

    if @page.update(page_params) && PageService.upload_images(@page)
      redirect_to edit_admin_page_path(@page), notice: alert_update(Page)
    else
      render :edit, status: 422
    end
  end

  def destroy
    page = Page.find_by!(url: params[:id])
    page.destroy!
    redirect_to admin_pages_url
  end

  def destroy_image
    page = Page.find_by!(url: params[:id])
    page_image = page.page_images.find(params[:image_id])

    page_image.destroy!
    @id = params[:image_id]
  end

  private

  def page_params
    params.require(:page).permit(:url, :visible, :title_sv, :title_en,
                                 :public, :namespace, image_upload: [])
  end
end
