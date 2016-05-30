class Admin::NoticesController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @notice_grid = initialize_grid(Notice)
  end

  def new
    @notice = Notice.new
  end

  def edit
    @notice = Notice.find(params[:id])
  end

  def create
    @notice = Notice.new(notice_params)
    @notice.user = current_user
    if @notice.save
      redirect_to edit_admin_notice_path(@notice),
                  notice: alert_create(Notice)
    else
      render :new, status: 422
    end
  end

  def update
    @notice = Notice.find(params[:id])
    @notice.user = current_user
    if @notice.update(notice_params)
      redirect_to edit_admin_notice_path(@notice),
                  notice: alert_update(Notice)
    else
      render :edit, status: 422
    end
  end

  def destroy
    notice = Notice.find(params[:id])

    notice.destroy!
    redirect_to admin_notices_url, notice: alert_destroy(Notice)
  end

  private

  def notice_params
    params.require(:notice).permit(:title_sv, :description_sv,
                                   :title_en, :description_en,
                                   :public, :d_publish, :d_remove,
                                   :sort, :image, :remove_image)
  end
end
