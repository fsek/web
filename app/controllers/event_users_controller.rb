class EventUsersController < ApplicationController
  before_action :load_permissions
  load_and_authorize_resource :event, parent: true
  load_and_authorize_resource :event_user, through: :event

  def create
    @event_user = @event.event_users.build(event_user_params)
    @event_user.user = current_user
    @event_user.save
    render
  end

  def destroy
    @event_user = current_user.event_users.find(params[:id])

    if @event_user.event_signup.open?
      @event_user.destroy!
      @event_user = @event.event_users.build
    end

    render
  end

  private

  def event_user_params
    params.require(:event_user).permit(:answer, :user_type, :group_id, :group_custom)
  end
end
