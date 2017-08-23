class Api::EventsController < Api::BaseController
  load_resource

  def index
    authorize!(:index, :api_event)

    @events = Event.includes(:translations).between(params[:start], params[:end])
    render json: @events, namespace: '' # Use the same serializer as for the web calendar
  end

  def show
    authorize!(:show, :api_event)

    render json: @event, scope: current_user # Event user included in serializer
  end
end
