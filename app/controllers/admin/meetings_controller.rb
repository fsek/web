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
  end

  def create
    if meeting_params[:occurrences].to_i > 0
      @first_meeting = MeetingService.create_recurring_meeting(meeting_params)
      if !@first_meeting.nil?
        redirect_to edit_admin_meeting_path(@first_meeting, edit_type: "all"), notice: alert_create(RecurringMeeting)
      else
        render :new, status: 422
      end
    else
      @meeting = Meeting.new(meeting_params)
      @meeting.by_admin = true
      @meeting.is_admin = true
      if @meeting.save
        redirect_to edit_admin_meeting_path(@meeting), notice: alert_create(Meeting)
      else
        render :new, status: 422
      end
    end
  end

  def update
    @meeting = Meeting.find(params[:id])
    @meeting.is_admin = true
    edit_type = params[:meeting][:edit_type]

    if edit_type == "one"
      if MeetingService.update_meeting(@meeting, meeting_params)
        MeetingMailer.update_email(@meeting, current_user).deliver_now unless @meeting.by_admin
        redirect_to edit_admin_meeting_path(@meeting), notice: alert_update(Meeting)
      else
        render :edit, status: 422
      end
    elsif edit_type == "all"
      @updated_meeting = MeetingService.update_all_recurring_meeting(@meeting, meeting_params)
      if !@updated_meeting.nil?
        redirect_to edit_admin_meeting_path(@updated_meeting, edit_type: "all"), notice: alert_update(RecurringMeeting)
      else
        render :edit, status: 422
      end
    elsif edit_type == "after"
      @updated_meeting = MeetingService.update_after_recurring_meeting(@meeting, meeting_params)
      if !@updated_meeting.nil?
        redirect_to edit_admin_meeting_path(@updated_meeting, edit_type: "after"), notice: alert_update(RecurringMeeting)
      else
        render :edit, status: 422
      end
    end
  end

  def destroy
    if MeetingService.destroy_meeting(@meeting)
      redirect_to admin_meetings_path, notice: alert_destroy(Meeting)
    else
      render :edit, status: 422
    end
  end

  private

  def meeting_params
    params.require(:meeting).permit(:start_date, :end_date, :title, :purpose, :room,
      :comment, :council_id, :user_id, :status, :every,
      :occurrences)
  end
end
