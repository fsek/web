class NoticesController < ApplicationController
  before_action :authenticate, except: [:image]
  before_action :set_notice, only: [:show, :edit, :update, :destroy, :hide, :display, :image]

  def index
    @notices = Notice.all
    @notice_grid = initialize_grid(@notices)
  end

  def show

  end

  def new
    @notice = Notice.new
  end

  def edit

  end

  def create
    @notice = Notice.new(notice_params)
    if @notice.save
      flash[:notice] = 'Notisen skapades.'
      redirect_to @notice
    else
      render action: :new
    end
  end

  def update
    if @notice.update(notice_params)
      flash[:notice] = 'Notisen uppdaterades'
      redirect_to @notice
    else
      render action: :edit
    end
  end

  def destroy
    @notice.destroy
    redirect_to notices_url
  end

  # Requested to hide the current Notice
  # /d.wessman
  def hide
    @notice.display(false)
  end

  # Requested to display the current Notice
  # /d.wessman
  def display
    @notice.display(true)
  end

  # Action to show notice picture
  def image
    if @notice.image?
      if (params[:style] == "original" || params[:style] == "large" || params[:style] == "small")
        send_file(@notice.image.path(params[:style]), filename: @notice.image_file_name, type: "image/jpg", disposition: 'inline', x_sendfile: true)
      else
        send_file(@notice.image.path(:large), filename: @notice.image_file_name, type: "image/jpg", disposition: 'inline', x_sendfile: true)
      end
    end
  end

  private
  def authenticate
    redirect_to(root_path, alert: t('the_role.access_denied')) unless current_user && (current_user.moderator?(:notiser))
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_notice
    @notice = Notice.find_by_id(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def notice_params
    params.require(:notice).permit(:title, :description, :public, :d_publish, :d_remove, :sort, :image)
  end

end
