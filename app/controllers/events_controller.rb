# encoding:UTF-8
class EventsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    respond_to do |format|
      format.json { render json: @events }
    end
  end

  def show
    if 1 == 0
      if @event.signup?
        if @event.attending(current_user)
          @event_registration = @event.event_registrations.find_by(user: current_user)
        else
          @event_registration = @event.event_registrations.build(user: current_user)
        end
      else
        @event_registration = nil
      end
    end
  end
end
