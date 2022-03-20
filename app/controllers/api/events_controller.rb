class Api::EventsController < Api::BaseController
  load_resource
  EVENT_SERIALIZER = ActiveModel::Serializer::EventSerializer

  def index
    authorize!(:index, :api_event)

    @events = Event.includes(:translations).between(params[:start], params[:end]).by_start
    render json: @events, namespace: "" # Use the same serializer as for the web calendar
  end

  def matrix
    authorize!(:matrix, :api_event)

    @introduction = Introduction.current
    if @introduction.nil?
      render json: {error: "No introduction exists"} and return
    end

    start = @introduction.start
    stop = @introduction.stop

    @events = Event.includes(:translations).between(start, stop).by_start
    @events = group_events(@events)

    render json: @events, namespace: ""
  end

  def scroll
    authorize!(:scroll, :api_event)

    # Loads all events for each day and atleast 7 in total
    @events = Event.includes(:translations).after_date(params[:start]).by_start.limit(7)
    if @events.length == 7
      last_day = Event.includes(:translations).from_date(@events[-1].starts_at).by_start
      @events = (@events.to_a + last_day.to_a).uniq
    end

    render json: @events, namespace: ""
  end

  def show
    authorize!(:show, :api_event)

    render json: @event, scope: current_user # Event user included in serializer
  end

  private

  def group_events(events)
    # Group events by week
    hash = Hash.new { |h, w| h[w] = [] }
    events.each_with_object(hash) do |event, h|
      h[event.starts_at.to_date.cweek].push(EVENT_SERIALIZER.new(event, scope: current_user).as_json)
    end
  end
end
