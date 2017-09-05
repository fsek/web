class EventsController < ApplicationController
  load_permissions_and_authorize_resource

  def show
    if @event.signup.present?
      @event_user = @event.event_users.where(user: current_user).first
      @event_user ||= @event.event_users.build
    end
  end
end
