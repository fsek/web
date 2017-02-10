class Admin::ShortLinksController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @short_link = ShortLink.new
  end

  def create
    @short_link = ShortLink.find_or_initialize_by(
      link: short_link_params[:link]
    )
    @short_link.update! short_link_params

    redirect_to admin_short_links_path, notice: alert_create(ShortLink)
  end

  def destroy
    ShortLink.find(params[:id]).destroy!

    redirect_to admin_short_links_path, notice: alert_destroy(ShortLink)
  end

  private

  def short_link_params
    params.require(:short_link).permit(:link, :target)
  end
end
