class Admin::RecurringMeetingsController < Admin::BaseController
  load_permissions_and_authorize_resource

  def destroy
    @recurring_meeting.destroy!
    redirect_to admin_meetings_path, notice: alert_destroy(RecurringMeeting)
  end

  private

  def recurring_meeting_params
    params.require(:recurring_meeting).permit(:every, :occurrences)
  end
end
