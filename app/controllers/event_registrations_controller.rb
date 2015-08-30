# encoding: UTF-8
class EventRegistrationsController < ApplicationController
  load_and_authorize_resource :event
  #before_action :set_event
  before_action :set_reg, only: [:create, :destroy]

  def index
    @event_registrations = current_user.try(:event_registrations)
  end

  def new
  end

  def create
    if EventRegistrationService.make_reg(@event_registration, current_user)
      redirect_to event_path(@event), notice: alert_create(EventRegistration)
    else
      render :new
    end
  end

  def destroy
    EventRegistrationService.remove_reg(@event_registration)
    redirect_to event_path(@event), notice: alert_destroy(EventRegistration)
  end

  private

  def event_registrations_params
    params.require(:event_registration).permit(:event_id, :user_id)
  end

  def set_reg
    @event_registration = @event.event_registrations.find_by(user: current_user) || @event.event_registrations.build(user: current_user)
  end

  def set_event
    @event = Event.find(params[:event_id])
  end
end
