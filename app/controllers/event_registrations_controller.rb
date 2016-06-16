# encoding: UTF-8
class EventRegistrationsController < ApplicationController
  load_permissions_and_authorize_resource
  load_and_authorize_resource :event

  def create
    @event_registration = @event.event_registrations.build(event_registration_params)
    @event_registration.user = current_user
    @state = EventRegistrationService.make_reg(@event_registration)
    render
  end

  def destroy
    EventRegistrationService.remove_reg(@event_registration)
    render
  end

  private

  def event_registration_params
    params.require(:event_registration).permit(:answer)
  end
end
