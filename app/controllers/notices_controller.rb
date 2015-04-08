class NoticesController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    @notice_grid = initialize_grid(@notices)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @notice.save
      redirect_to @notice, notice: %(#{t(:notice)} #{t(:success_create)}.)
    else
      render action: :new
    end
  end

  def update
    if @notice.update(notice_params)
      redirect_to @notice, notice: %(#{t(:notice)} #{t(:success_update)}.)
    else
      render action: :edit
    end
  end

  def destroy
    @notice.destroy
    redirect_to notices_url
  end

  def image
    if @notice.image?
      if params[:style] == 'original' || params[:style] == 'large' || params[:style] == 'small'
        send_file(@notice.image.path(params[:style]),
                  filename: @notice.image_file_name, type: 'image/jpg',
                  disposition: 'inline', x_sendfile: true)
      else
        send_file(@notice.image.path(:large),
                  filename: @notice.image_file_name, type: 'image/jpg',
                  disposition: 'inline', x_sendfile: true)
      end
    end
  end

  private

  def notice_params
    params.require(:notice).permit(:title, :description,
                                   :public, :d_publish, :d_remove,
                                   :sort, :image)
  end
end
