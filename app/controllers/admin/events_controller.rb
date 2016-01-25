# encoding:UTF-8
class Admin::EventsController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :authorize

  def index
    @events = Event.order(starts_at: :desc)
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
    @event.author = current_user
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
    @event.destroy
    redirect_to admin_events_path, notice: alert_destroy(Event)
  end

  private

  def event_params
    params.require(:event).permit(:title, :author, :description,
                                  :location, :starts_at, :ends_at,
                                  :all_day, :category, :image,
                                  :signup, :last_reg,
                                  :slots, :drink, :food, :cash,
                                  :short, :council_id, :dot)
  end

  def authorize
    authorize! :manage, Event
  end
end

