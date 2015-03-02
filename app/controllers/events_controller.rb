# encoding:UTF-8
class EventsController < ApplicationController
  
    before_filter :login_required, only: [:calendar,:show]
    before_filter :authenticate, only: [:new,:edit,:create,:update,:destroy]
    before_action :utskott, only: [:new,:edit]
    before_action :set_event, only: [:show,:edit,:update,:destroy]
        
  # GET /events
  # GET /events.json
  def index
    @events = Event.all    
    respond_to do |format|
      format.html { redirect_to :kalender}
      format.json { render :json => @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @author = Profile.find_by_id(@event.author)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @event }
    end
  end
  def calendar
    
  end
  def export
    @events = Event.all        
    @calendar=Icalendar::Calendar.new 
    for event in @events
      @calendar.add_event(event.ical(polymorphic_url(event, :routing_type => :url))) 
    end
    @calendar.publish      
    respond_to do |format|
      format.ics
    end
  end
  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @event }
    end
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.update(author: current_user.profile)
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, :notice => 'Eventet skapades!' }
        format.json { render :json => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.json { render :json => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find_by_id(params[:id])    
    respond_to do |format|
      if @event.update_attributes(event_params)
        format.html { redirect_to @event, :notice => 'Eventet uppdaterades!' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
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
        params.require(:event).permit(:title,:author,:description,:location,:starts_at,:ends_at,:all_day,:category,:image)
      end
      def utskott
        @utskott = Council.all
      end
end