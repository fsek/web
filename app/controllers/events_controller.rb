# encoding:UTF-8
class EventsController < ApplicationController

  before_filter :login_required, only: [:calendar, :show]
  before_filter :authenticate, only: [:new, :edit, :create, :update, :destroy]
  before_action :utskott, only: [:new, :edit]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = Event.all
    respond_to do |format|
      format.html { redirect_to :kalender }
      format.json { render :json => @events }
    end
  end

  def show
    @author = User.find_by_id(@event.author)
  end

  def calendar
  end

  def export
    @events = Event.all
    @calendar=Icalendar::Calendar.new
    for event in @events
      @calendar.add_event(event.ical)
    end
    @calendar.publish
    respond_to do |format|
      format.ics
    end
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def create
    @event = Event.new(event_params)
    @event.author = current_user
    if @event.save
      flash[:notice] = 'Kandidaturen skapades.'
      redirect_to @event
    else
      render action: :new
    end
  end

  def update
    if @event.update(event_params)
      flash[:notice] = 'Eventet uppdaterades'
      redirect_to @event
    else
      render action: :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to events_url
  end

  private
  def authenticate
    flash[:error] = t('the_role.access_denied')
    redirect_to(:back) unless current_user && current_user.moderator?(:event)

  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  def set_event
    @event = Event.find_by_id(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :author, :description, :location, :starts_at, :ends_at, :all_day, :category, :image)
  end

  def utskott
    @utskott = Council.all
  end
end
