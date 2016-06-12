# encoding:UTF-8
class EventsController < ApplicationController
  load_permissions_and_authorize_resource

  def show
    @event_registration = @event.event_registrations.where(user: current_user).first
    @event_registration ||= @event.event_registrations.build
  end
end
