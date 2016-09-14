class Admin::EventUsersController < Admin::BaseController
  before_action :load_permissions
  load_permissions_and_authorize_resource
  load_and_authorize_resource :event

  def edit
  end

  def update
    @event_user.is_admin = true
    if @event_user.update(event_user_params)
      redirect_to admin_event_signup_path(@event, tab: :attendees), notice: alert_update(EventUser)
    else
      render :edit, status: 422
    end
  end

  def destroy
    @event_user.destroy!
    redirect_to admin_event_signup_path(@event, tab: :attendees), notice: alert_destroy(EventUser)
  end

  private

  def event_user_params
    params.require(:event_user).permit(:user_type, :group_id, :group_custom)
  end
end
