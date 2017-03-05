class Admin::MeetingsController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @meetings = Meeting.from_date(Time.zone.now.beginning_of_week).includes(:user)
    @grid = initialize_grid(@meetings, order: :start_date)
  end

  def show
  end

  def new
    @meeting.user = current_user
    @meeting.status = :confirmed
    @meeting.room = params.fetch(:room, 'sk')
  end

  def create
    @meeting = Meeting.new(meeting_params)
    @meeting.by_admin = true
    @meeting.is_admin = true

    if @meeting.save
      redirect_to edit_admin_meeting_path(@meeting), notice: alert_create(Meeting)
    else
      render :new, status: 422
    end
  end

  def update
    @meeting = Meeting.find(params[:id])
    @meeting.is_admin = true

    if @meeting.update(meeting_params)
      MeetingMailer.update_email(@meeting, current_user).deliver_now unless @meeting.by_admin
      redirect_to edit_admin_meeting_path(@meeting), notice: alert_update(Meeting)
    else
      render :edit, status: 422
    end
  end

  def destroy
    @meeting.destroy!
    redirect_to admin_meetings_path, notice: alert_destroy(Meeting)
  end

  private

  def meeting_params
    params.require(:meeting).permit(:start_date, :end_date, :title, :purpose, :room,
                                    :comment, :council_id, :user_id, :status)
  end
end
