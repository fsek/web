class Api::EventsController < Api::BaseController
  load_permissions_and_authorize_resource

  def index
    @events = Event.all
    render json: @events, namespace: '' # Use the same serializer as for the web calendar
  end

  def show
    render json: @event, scope: current_user # Event user included in serializer
  end
end
