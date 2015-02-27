class NoticesController < ApplicationController
  before_action :authenticate, except: [:image]
  before_action :set_notice, only: [:show, :edit, :update, :destroy,:hide,:display,:image]

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
    respond_to do |format|
      if @notice.save
        format.html { redirect_to @notice, notice: %(#{t(:notice)} #{t(:success_create)}.)}
        format.json { render action: 'show', status: :created, location: @notice }
      else
        format.html { render action: 'new' }
        format.json { render json: @notice.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @notice.update(notice_params)
        format.html { redirect_to @notice, notice: %(#{t(:notice)} #{t(:success_update)}.) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @notice.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @notice.destroy
    respond_to do |format|
      format.html { redirect_to notices_url }
      format.json { head :no_content }
    end
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

  # Action to show profile picture only already authenticated
  def image
    if @notice.image?
      if(params[:style] == "original" || params[:style] == "large" || params[:style] == "small")
        send_file(@notice.image.path(params[:style]), filename:@notice.image_file_name, type: "image/jpg",disposition: 'inline',x_sendfile: true)
      else
        send_file(@notice.image.path(:large), filename:@notice.image_file_name, type: "image/jpg",disposition: 'inline',x_sendfile: true)
      end
    end
  end

  private
    def authenticate
      redirect_to(root_path, alert: t('the_role.access_denied')) unless current_user &&  (current_user.moderator?(:notiser))
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_notice
      @notice = Notice.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notice_params
      params.require(:notice).permit(:title, :description, :public, :d_publish, :d_remove, :sort,:image)
    end

end
