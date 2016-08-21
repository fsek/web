class EventUsersController < ApplicationController
  before_action :load_permissions
  load_and_authorize_resource :event, parent: true
  load_and_authorize_resource :event_user, through: :event

  def create
    @event_user = @event.event_users.build(event_user_params)
    @event_user.user = current_user
    EventRegistrationService.make_reg(@event_user)
    render
  end

  def destroy
    @event_user = current_user.event_users.find(params[:id])
    EventRegistrationService.remove_reg(@event_user)
    render
  end

  private

  def event_user_params
    params.require(:event_user).permit(:answer, :user_type, :group_id)
  end
end
