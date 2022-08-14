class Admin::EventsController < Admin::BaseController
  load_permissions_and_authorize_resource
  before_action :set_tab, only: [:new, :edit, :create, :update]

  def index
    @event_grid = initialize_grid(Event,
                                  include: :event_signup,
                                  locale: :sv,
                                  order: :starts_at,
                                  order_direction: :desc)
  end

  def new
    @event = Event.new
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to edit_admin_event_path(@event), notice: alert_create(Event)
    else
      render :new, status: 422
    end
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to edit_admin_event_path(@event), notice: alert_update(Event)
    else
      render :edit, status: 422
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy!

    redirect_to admin_events_path, notice: alert_destroy(Event)
  end

  private

  def event_params
    params.require(:event).permit(:title_sv, :title_en, :description_sv, :description_en,
                                  :short_sv, :short_en,
                                  :location_sv, :location_en, :starts_at, :ends_at,
                                  :all_day, :image, :remove_image,
                                  :drink, :food, :cash, :price, :contact_id,
                                  :council_id, :dot, dress_code: [],
                                  category_ids: [])
  end

  def set_tab
    @tab = params.fetch(:tab, :event_texts).to_sym
  end
end
