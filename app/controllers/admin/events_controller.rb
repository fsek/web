# encoding:UTF-8
class Admin::EventsController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :authorize

  def index
    respond_to do |format|
      format.html
      format.json { render json: @events }
    end
  end

  def show
  end

  def new
    @tab = :info
  end

  def edit
    @tab = :info
  end

  def create
    @event.author = current_user
    if @event.save
      redirect_to admin_event_path(@event), notice: alert_create(Event)
    else
      @tab = :info
      render action: :new
    end
  end

  def update
    if @event.update(event_params)
      redirect_to edit_admin_event_path(@event), notice: alert_update(Event)
    else
      @tab = :info
      render action: :edit
    end
  end

  def destroy
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
                                  :short, :council_id)
  end

  def authorize
    authorize! :manage, Event
  end
end

