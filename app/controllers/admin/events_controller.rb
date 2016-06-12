# encoding:UTF-8
class Admin::EventsController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @events = Event.includes(:translations).order(starts_at: :desc)
  end

  def new
    @event = Event.new
    @tab = :info
  end

  def edit
    @event = Event.find(params[:id])
    @tab = :info
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to edit_admin_event_path(@event), notice: alert_create(Event)
    else
      @tab = :info
      render :new, status: 422
    end
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to edit_admin_event_path(@event), notice: alert_update(Event)
    else
      @tab = :info
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
                                  :location, :starts_at, :ends_at,
                                  :all_day, :image, :remove_image,
                                  :signup, :last_reg, :for_members,
                                  :slots, :drink, :food, :cash,
                                  :council_id, :dot, :question, category_ids: [])
  end
end
